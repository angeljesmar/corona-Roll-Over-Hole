local widget = require( "widget" )
local composer = require( "composer" )
local ads = require( "ads" )

local scene = composer.newScene()
local uiGroup = display.newGroup()

local function createPlayButton( )
    
    local btn = widget.newButton ( {
        width = 172,
        height = 180,
        defaultFile = "images/play.png",
        x=display.contentWidth/2, 
        y=95, 
        onRelease=function() 
            ads.show( "interstitial", { appId=interstitialAppID } )
            composer.gotoScene("game") 
        end
    } )
    
    uiGroup:insert( btn )

end

local function createSettingsButton( )
    local btn = widget.newButton ( {
        label="Налаштування",x=display.contentWidth/2, y=190, onRelease=function() composer.gotoScene("configurations") end
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
    ads.show( "banner", { x=0 , y=460, appId=bannerAppID } )

    createPlayButton()
    createSettingsButton()
    
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