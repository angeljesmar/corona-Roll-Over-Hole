local widget = require( "widget" )
local composer = require( "composer" )
local scene = composer.newScene()
local uiGroup = display.newGroup()

local function createPlayButton( )
    
    local btn = widget.newButton ( {
        label="Грати",x=display.contentWidth/2, y=10, onRelease=function() composer.gotoScene("game") end
    })
    
    uiGroup:insert( btn )

end

local function createSettingsButton( )
    local btn = widget.newButton ( {
        label="Налаштування",x=display.contentWidth/2, y=50, onRelease=function() composer.gotoScene("configurations") end
    })
    
    uiGroup:insert( btn )
end

local function createLeadershipButton( )
    local btn = widget.newButton ( {
        label="Дошка лідерів (experimental)",x=display.contentWidth/2, y=90, onRelease=function() composer.gotoScene("configurations") end
    })
    
    uiGroup:insert( btn )
end

-- create()
function scene:create( event )
    createSettingsButton()
    createPlayButton()
    -- createLeadershipButton()
end


-- show()
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then

    elseif ( phase == "did" ) then
    	
    end
end


-- hide()
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
    	composer.removeScene( "menu" )
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