
-- -----------------------------------------------------------------------------------
-- Scene event functions
-- -----------------------------------------------------------------------------------
-- rohSettings = {
--     speed = 100,
--     ballSensetivity = 280,
--     acceleration = 15,
--     accelerationFrequency = 8,
--     bonusFrequency = 5
-- }

local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()
local uiGroup = display.newGroup()

local function createStartSpeed( )
    local label = display.newText( "Стартова швидкість: ", 5, 0, native.systemFont, 15 )
    label.anchorX = 0
    uiGroup:insert( label )
    speed = native.newTextField( 150, 0, 50, 20 )
    speed.anchorX = 0
    speed.inputType = "number"
    speed.text = rohSettings.speed
    uiGroup:insert( speed )
end

local function createBallSensitivity( )
    local label = display.newText( "Чутливість мяча: ", 5, 30, native.systemFont, 15 )
    label.anchorX = 0
    uiGroup:insert( label )
    ballSensetivity = native.newTextField( 150, 30, 50, 20 )
    ballSensetivity.anchorX = 0
    ballSensetivity.inputType = "number"
    ballSensetivity.text = rohSettings.ballSensetivity
    uiGroup:insert( ballSensetivity )
end

local function createAcceleration( )
    local label = display.newText( "Прискорення: ", 5, 60, native.systemFont, 15 )
    label.anchorX = 0
    uiGroup:insert( label )
    acceleration = native.newTextField( 150, 60, 50, 20 )
    acceleration.anchorX = 0
    acceleration.inputType = "number"
    acceleration.text = rohSettings.acceleration
    uiGroup:insert( acceleration )
end

local function createAccelerationFrequency( )
    local label = display.newText( "Частота прискорення(секунди): ", 5, 90, native.systemFont, 15 )
    label.anchorX = 0
    uiGroup:insert( label )
    accelerationFrequency = native.newTextField( 220, 90, 50, 20 )
    accelerationFrequency.anchorX = 0
    accelerationFrequency.inputType = "number"
    accelerationFrequency.text = rohSettings.accelerationFrequency
    uiGroup:insert( accelerationFrequency )
end

local function createBonusFrequency( )
    local label = display.newText( "Частота випадіння бонусу(секунди): ", 5, 120, native.systemFont, 15 )
    label.anchorX = 0
    uiGroup:insert( label )
    bonusFrequency = native.newTextField( 250, 120, 50, 20 )
    bonusFrequency.anchorX = 0
    bonusFrequency.inputType = "number"
    bonusFrequency.text = rohSettings.bonusFrequency
    uiGroup:insert( bonusFrequency )
end

local function save( )
    rohSettings.speed                   = speed.text
    rohSettings.ballSensetivity         = ballSensetivity.text
    rohSettings.bonusFrequency          = bonusFrequency.text
    rohSettings.acceleration            = acceleration.text
    rohSettings.accelerationFrequency   = accelerationFrequency.text
    commitSettings()
    composer.gotoScene( "menu" )
end

-- create()
function scene:create( event )
    createStartSpeed()
    createAcceleration()
    createBonusFrequency()
    createAccelerationFrequency()
    createBallSensitivity()
    local btn = widget.newButton ({
        label="Зберегти", x=display.contentWidth/2, y=400, onRelease=save
    })
    uiGroup:insert( btn )
end


-- show()
function scene:show( event )
    bg.isVisible = false
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
    	
    end
end


-- hide()
function scene:hide( event )
    bg.isVisible = true
    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    	composer.removeScene( "configurations" )
    elseif ( phase == "did" ) then
        -- Code here runs immediately after the scene goes entirely off screen

    end
end


-- destroy()
function scene:destroy( event )

    local sceneGroup = self.view
    display.remove( uiGroup )

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