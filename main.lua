-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
local settings = require("settings")
local preferences = require( "preference" )
local ads = require( "ads" )

local function onAdsReady(event)
    print("event from ads " .. event)
end

bannerAppID = "ca-app-pub-3419733645071199/4237594663"
interstitialAppID = "ca-app-pub-3419733645071199/3127461465"

ads.init( "admob", "ca-app-pub-3419733645071199~2867096264", onAdsReady )
-- ads.init( "admob", interstitialAppID, onAdsReady )

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

bg = display.newImageRect( "images/bg.png",
               display.contentWidth, display.contentHeight * 2) 
bg.x = display.contentCenterX
bg.y = display.contentCenterY

local function main()
	local composer = require("composer")
	composer.gotoScene("menu")
end

main()
