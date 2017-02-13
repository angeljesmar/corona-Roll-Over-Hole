local composer = require( "composer" )
local widget = require( "widget" )
local scene = composer.newScene()
local result = 0

local uiGroup = display.newGroup()
 
function scene:hide( event )
    local sceneGroup = self.view
    local phase = event.phase
    local parent = event.parent  --reference to the parent scene object
 
    if ( phase == "will" ) then
        composer.removeScene( "retry" )
        parent.onComplete( result )
    end
end

function scene:create( event )
	local callback = event.onComplete

    local btn = widget.newButton ( {
        width = 300,
        height = 150,
        defaultFile = "images/retry.png",
        overFile = "images/retry_pressed.png",
        x=display.contentWidth/2, 
        y=95, 
        onRelease=function() 
            result = 1
            composer.hideOverlay()
        end
    } )
    
    uiGroup:insert( btn )

    btn = widget.newButton ( {
        width = 300,
        height = 150,
        defaultFile = "images/finish.png",
        overFile = "images/finish_pressed.png",
        x=display.contentWidth/2, 
        y=250, 
        onRelease=function() 
            result = 2
            composer.hideOverlay()
        end
    } )
    
    uiGroup:insert( btn )
end

function scene:destroy( event )

    local sceneGroup = self.view
    display.remove( uiGroup )

end
 
-- By some method (a "resume" button, for example), hide the overlay
composer.hideOverlay( "fade", 400 )
 
scene:addEventListener( "hide", scene )
scene:addEventListener( "create", scene )
scene:addEventListener( "destroy", scene )

return scene