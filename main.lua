-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local settings = require("settings")
local preferences = require( "preference" )
local ads = require( "ads" )

local function onAdsReady()
	ads.show( "banner", { x=display.contentWidth/2, y=460, testMode=true } )
end

ads.init( "admob", "ca-app-pub-3419733645071199~2867096264", onAdsReady )
rohSettings = preferences.getValue( "settings" )
function commitSettings( )
	-- saveTable(rohSettings, "rohSettings.json")
	preferences.save( { settings = rohSettings } )
end

if not rohSettings then  
    rohSettings = {
    	highscore = 0,
		speed = 100,
		ballSensetivity = 280,
		acceleration = 15,
		accelerationFrequency = 8,
		bonusFrequency = 5,
		jumpDuration = 3000,
		slowmotionDuration = 3000
	}
    commitSettings()
end

display.setStatusBar( display.HiddenStatusBar )

local image = display.newImageRect( "images/bg.png",
               display.contentWidth, display.contentHeight * 2) 
image.x = display.contentCenterX
image.y = display.contentCenterY

local function main()
	local composer = require("composer")
	composer.gotoScene("menu")
end

main()
