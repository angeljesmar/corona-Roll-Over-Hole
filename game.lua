-----------------------------------------------------------------------------------------
--
-- game.lua
--
-----------------------------------------------------------------------------------------
local physics = require( "physics" )
local widget = require( "widget" )
local composer = require( "composer" )
undead = false

local holeTable = {}
local bonusTable = {}
local ball
local scores = 0

local gameSpeed = rohSettings.speed
local ballSensetivity = rohSettings.ballSensetivity
local acceleration = rohSettings.acceleration
local accelerationFrequency = rohSettings.accelerationFrequency
local bonusFrequency = rohSettings.bonusFrequency
local slowmotionDuration = rohSettings.slowmotionDuration
local jumpDuration = rohSettings.jumpDuration
local initJumpsCount = 1
local maxJumps = 3

local jumpsCount = 0
local speedScale = 1
local ballSpeed = 0

local backGroup 
local mainGroup 
local bonusGroup
local uiGroup
local holeGroup

local scoreText, jumpsText

local function createSystemText()
	local options = {
	   width = 30,
	   height = 30,
	   numFrames = 17
	}
	local sheet = graphics.newImageSheet( "images/bonus.png", options )
	local sequenceData = {
	    name = "spinning",
	    time = 1000,
	    start = 1, 
	    count = 17
	}
 
 	local bonus = display.newSprite( sheet, sequenceData )
 	bonus.anchorX = 0
 	bonus.x = 0
 	bonus.y = 500
 	uiGroup:insert( bonus )
 	bonus:play()

	scoreText = display.newText( uiGroup, scores, 30, 500, native.systemFont, 22 )
	scoreText.anchorX = 0
	table.insert( uiGroup, scoreText )
	

	jumpsText = display.newText( uiGroup, "Jumps: " .. jumpsCount, 0, 0, native.systemFont, 16 )
	jumpsText.anchorX = 0
	table.insert( uiGroup, jumpsText )
end

local function updateScores()
    scoreText.text = scores .. "(" .. rohSettings.highscore .. ")"
end

local function updateJumps()
	jumpsText.text = "Jumps: " .. jumpsCount .. "(max = " .. maxJumps .. ")"
end

local function createBall()
	local options = {
	   width = 30,
	   height = 30,
	   numFrames = 10
	}
	local sheet = graphics.newImageSheet( "images/ball.png", options )
	local sequenceData = {
	    name = "rolling",
	    time = 500,
	    start = 1, 
	    count = 9
	}
 
 	ball = display.newSprite( sheet, sequenceData )

 	ball.rotation = -90
	ball.x = display.contentWidth/2
	ball.y = 420

	mainGroup:insert( ball )

	ball:play()
	ball.name = "ball"

	physics.addBody( ball, "dynamic", { radius=10, density=1, friction=0, bounce=0 } )

	ball.setSpeed = function( self, speed )
		self:setLinearVelocity( speed, 0 )
	end
	
	ball.jump = function( self )
		if not self.isJumping then
			self.isJumping = true
			transition.scaleTo( self, { xScale=1.5, yScale=1.5, time=100 } )
		end
	end

	ball.finishJump = function( self )
		if self.isJumping then
			self.isJumping = true
			transition.scaleTo( self, { xScale=1, yScale=1, time=100, 
				onComplete = function()
					self.isJumping = false
				end 
			})
		end
	end

	ball.anchorX = 0.5
	ball.anchorY = 0.5
end

local function createHole()
	local hole = display.newImage( "images/hole.png" )
	hole.name = "hole"

	holeGroup:insert( hole )

	hole.setSpeed = function( self, speed )
		self:setLinearVelocity( 0, speed * speedScale )
	end

	hole.y = -90
	hole.x = math.random(320)
	
	table.insert( holeTable, hole )
	physics.addBody( hole, "kinematic", { radius=15, bounce=0 } )
	hole.isSensor = true
	hole:setSpeed( speed )
end

local function gameLoop()
    createHole()

    for i = #holeTable, 1, -1 do
        local hole = holeTable[i]

        if ( hole.y > display.contentHeight + 100 ) then
        	display.remove( hole )
            table.remove( holeTable, i )
        end
    end

    scores = scores + 1
	
	updateScores()
	uiGroup:toFront()
	mainGroup:toFront()
	bonusGroup:toFront()

end

local function updateSpeed()
	local measuredSpeed = speed * speedScale
	if (measuredSpeed > 0) then
		local scale = gameSpeed / measuredSpeed
		timer.cancel( gameLoopTimer )
		gameLoopTimer = timer.performWithDelay( 500.0 * scale, gameLoop, 0 )
		ball.timeScale = 1.0 / scale
	end
	for i, hole in ipairs(holeTable) do hole:setSpeed( speed ) end
	for i, bonus in ipairs(bonusTable) do 
		if bonus and not bonus.collected then bonus:setSpeed( speed ) end 
	end
end 

local function useJumpBonus()
	if jumpsCount == 0 or ball.isJumping then return end
	jumpsCount = jumpsCount - 1
	updateJumps()

	ball:jump()
	if (jumpTimer) then timer.cancel( jumpTimer ) end
	jumpTimer = timer.performWithDelay( jumpDuration, function() 
		ball:finishJump()
		jumpTimer = nil
	end, 1)
end

local function onAccelerate( event )
	if event.isShake then
		useJumpBonus()
	end
	local speed = event.xGravity * ballSensetivity
	
	updateScores()
	ball:setSpeed( speed )
end

local function showDieAlert( )
	local function onComplete( event )
	    if ( event.action == "clicked" ) then
	        local i = event.index
	        if ( i == 1 ) then
	            startGame( )
	        elseif ( i == 2 ) then
	            composer.gotoScene( "menu" )
	        end
	    end
	end
	local alert = native.showAlert( "End", "You died", { "Retry", "Finish" }, onComplete )
end

local function collectBonus( bonusType )
	if bonusType == 1 then
		speedScale = 0.5
		if (speedScaleTimer) then timer.cancel( speedScaleTimer ) end
		speedScaleTimer = timer.performWithDelay( slowmotionDuration, function()
			speedScale = 1
			updateSpeed()
			speedScaleTimer = nil
		end, 1 )
		updateSpeed()
	elseif bonusType == 2 then
		if jumpsCount < maxJumps then 
			jumpsCount = jumpsCount + 1 
			updateJumps()
		end
	elseif bonusType == 3 then
		scores = scores + 10
		updateScores()
	end
end

local function showHowBitchDie( hole )
	speed = 0
	ballSpeed = 0
	updateSpeed()

	transition.to( ball, { time=200, x=hole.x, y=hole.y, onComplete=function()
		transition.scaleTo( ball, { time=400, yScale=0.2, xScale=0.2, onComplete=function()
			stopGame()
			showDieAlert()
		end} )
	end} )

end

local function onCollision( event )
    if ( event.phase == "began" ) then
        local obj1 = event.object1
        local obj2 = event.object2
		if ( ( obj1.name == "ball" and obj2.name == "hole" ) or
             ( obj1.name == "hole" and obj2.name == "ball" ) ) 
		then 
			if not ball.isJumping and not undead then
				showHowBitchDie( obj1.name == "hole" and obj1 or obj2 )
			end
		elseif ( ( obj1.name == "ball" and obj2.name == "bonus" ) or
             ( obj1.name == "bonus" and obj2.name == "ball" ) ) 
		then
			local bonus = obj1.name == "bonus" and obj1 or obj2

			if not bonus.collected then
				collectBonus(bonus.bonusType)
				bonus.collected = true
				display.remove( bonus )
			end
		end
    end
end

local function addGravityController( )
	gravityController = display.newCircle( mainGroup, 160, 460, 20 )
	gravityController:setFillColor( 0.5 )
	function gravityController:touch( event )
		if event.phase == "began" then

		    display.getCurrentStage():setFocus( event.target )
		    self.markX = self.x    -- store x location of object
		    self.markY = self.y    -- store y location of object

		elseif event.phase == "moved" then

		    local x = (event.x - event.xStart) + self.markX
		    self.x = x
		    ball:setSpeed(x - 160)

		elseif event.phase == "ended"  or event.phase == "cancelled" then

		    display.getCurrentStage():setFocus(nil)

		end
		return true
	end
	gravityController:addEventListener("touch", gravityController)
end

local function addBorders( )
	left = display.newLine(0, 240, 0, 720)
	left.isVisible = false
	right = display.newLine(320, 240, 320, 720)
	right.isVisible = false
	physics.addBody(left, 'static', {filter = {categoryBits = 4, maskBits = 7}})
    physics.addBody(right, 'static', {filter = {categoryBits = 4, maskBits = 7}})
end

local function generateBonus( )
	local function createBonus( bonusType )
		local bonus
		if bonusType == 3 then
			local options = {
			   width = 30,
			   height = 30,
			   numFrames = 17
			}
			local sheet = graphics.newImageSheet( "images/bonus.png", options )
			local sequenceData = {
			    name = "spinning",
			    time = 1000,
			    start = 1, 
			    count = 17
			}
		 
		 	bonus = display.newSprite( sheet, sequenceData )
		 	bonus.y = -90
			bonusGroup:insert(bonus)

			bonus:play()
		else 
			bonus = display.newCircle( bonusGroup, 0, -90, 15 )
			
			bonus:setFillColor( 0, 1, 0 )
			bonus.strokeWidth = 4

			-- 0 - blue - jump, 1 - red - slowmotion, 2 - yellow - bonus
			local stroke = function() 
			 	if bonusType == 1 then 
			 		return 0, 0, 1 
			 	elseif bonusType == 2 then 
			 		return 1, 0, 0 
			 	elseif bonusType == 3 then 
			 		return 1, 1, 0 
			 	end
			end
			bonus:setStrokeColor( stroke() )
		end
		
		bonus.name = "bonus"
		bonus.bonusType = bonusType

		bonus.setSpeed = function( self, speed )
			self:setLinearVelocity( 0, speed * speedScale )
		end

		x = math.random(320)
		bonus.x = x
		
		table.insert( bonusTable, bonus )
		bonus.index = #bonusTable
		physics.addBody( bonus, "kinematic", { radius=15, bounce=0, dencity=0 } )
		bonus.isSensor = true
		bonus:setSpeed( speed )
	end
	createBonus(3)
	for i = #bonusTable, 1, -1 do
        local bonus = bonusTable[i]
        if bonus.collected then 
        	table.remove( bonusTable, i ) 
        elseif ( bonus and bonus.y > display.contentHeight + 100 ) then
        	display.remove( bonus )
            table.remove( bonusTable, i )
        end
    end
end

function startGame()
	backGroup = display.newGroup() 
	mainGroup = display.newGroup() 
	bonusGroup = display.newGroup() 
	uiGroup = display.newGroup() 
	holeGroup = display.newGroup()

    createSystemText()
	addBorders()
	createBall()

	scores = 0
	ballSpeed = 0
	speed = gameSpeed
	jumpsCount = initJumpsCount
	updateJumps()
	gameLoopTimer = timer.performWithDelay( 500, gameLoop, 0 )
	speedLoopTimer = timer.performWithDelay( accelerationFrequency * 1000, function()
		speed = speed + acceleration
		updateSpeed()
	end, 0 )
	bonusLoopTimer = timer.performWithDelay( bonusFrequency * 1000, generateBonus, 0)
	Runtime:addEventListener( "collision", onCollision )
	Runtime:addEventListener( "accelerometer", onAccelerate )
end

function stopGame()
	Runtime:removeEventListener( "accelerometer", onAccelerate )
	Runtime:removeEventListener( "collision", onCollision )
	timer.cancel( gameLoopTimer )
	timer.cancel( speedLoopTimer )
	timer.cancel( bonusLoopTimer )
	if (speedScaleTimer) then timer.cancel( speedScaleTimer ) end
	if (jumpTimer) then timer.cancel( jumpTimer ) end
	
	mainGroup:removeSelf()
	holeGroup:removeSelf()
	bonusGroup:removeSelf()
	uiGroup:removeSelf()
	backGroup:removeSelf()

	mainGroup = nil
	bonusGroup = nil
	uiGroup = nil
	holeGroup = nil
	backGroup = nil

	holeTable = {}
	bonusTable = {}

	if scores > rohSettings.highscore then 
		rohSettings.highscore = scores 
		commitSettings()
	end

	speed = 0
	scores = 0
end

local composer = require( "composer" )

local scene = composer.newScene()


function scene:create( event )
	physics.start()
	physics.setGravity( 0, 0 )

	math.randomseed( os.time() )

    local sceneGroup = self.view
    -- addGravityController()

	system.setAccelerometerInterval( 50 );
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    	startGame()
    elseif ( phase == "did" ) then
    	-- resumeGame()
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    	composer.removeScene( "game" )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view

end


-- -----------------------------------------------------------------------------------
-- Scene event function listeners
-- -----------------------------------------------------------------------------------
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
-- -----------------------------------------------------------------------------------

return scene
