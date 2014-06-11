-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

local composer = require( "composer" )
local scene = composer.newScene()

-- include Corona's "widget" library
local widget = require "widget"
-- load the JSON library
local json = require "json"

--------------------------------------------

-- forward declarations and other locals
local playBtn
local continueBtn
local teamInfoBtn
local continueBtn
local confirmBtn
local savedGameExists

local path = system.pathForFile( "savedGame", system.DocumentsDirectory )
local fileHandle, errorString = io.open(path, "r")
if fileHandle then
	print "opened"
	savedGameExists = true
	io.close(fileHandle)
else
	print "failed"
	savedGameExists = false
end

local function confirmBtnRelease()

	-- go to game.lua scene
	composer.gotoScene( "teamSelect", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for playBtn
local function playBtnRelease()
	
	-- confirm deletion of old save files, if any
	if savedGameExists then
		confirmBtn.isVisible = true
	else
		-- go to game.lua scene
		composer.gotoScene( "teamSelect", "fade", 500 )
	end
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for teamInfoBtn
local function teamInfoBtnRelease()
	
	-- go to game.lua scene
	composer.gotoScene( "teamInfo", "fade", 500 )
	
	return true	-- indicates successful touch
end

-- 'onRelease' event listener for continueBtn
local function continueBtnRelease()

	-- go to teamInfo.lua scene
	composer.gotoScene( "game", "fade", 500 )
	
	return true	-- indicates successful touch
end

function scene:create( event )
	local sceneGroup = self.view

	-- Called when the scene's view does not exist.
	-- 
	-- INSERT code here to initialize the scene
	-- e.g. add display objects to 'sceneGroup', add touch listeners, etc.

	-- display a background image
	local background = display.newImageRect( "background.jpg", display.contentWidth, display.contentHeight )
	background.anchorX = 0
	background.anchorY = 0
	background.x, background.y = 0, 0
	
	-- create/position logo/title image on upper-half of the screen
	local titleLogo = display.newImageRect( "logo.png", 264, 42 )
	titleLogo.x = display.contentWidth * 0.5
	titleLogo.y = 100
	
	-- create a widget button (which will loads game.lua on release)
	playBtn = widget.newButton{
		label="New Game",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = playBtnRelease	-- event listener function
	}
	playBtn.x = display.contentWidth*0.5
	playBtn.y = display.contentHeight - 175

	-- create a widge button (which will load teamInfo.lua on release)
	teamInfoBtn = widget.newButton{
		label="Team Info",
		labelColor = { default={255}, over={128} },
		default="button.png",
		over="button-over.png",
		width=154, height=40,
		onRelease = teamInfoBtnRelease	-- event listener function
	}
	teamInfoBtn.x = display.contentWidth*0.5
	teamInfoBtn.y = display.contentHeight - 150

	-- create a widge button (which will load game.lua with saved data on release)
	-- if there is no saved game, the button will do nothing
	if savedGameExists then
		continueBtn = widget.newButton{
			label="Continue",
			labelColor = { default={255}, over={128} },
			default="button.png",
			over="button-over.png",
			width=154, height=40,
			onRelease = continueBtnRelease	-- event listener function
		}
	else
		continueBtn = widget.newButton{
			label="Continue",
			labelColor = { default={255}, over={128} },
			default="button.png",
			over="button-over.png",
			width=154, height=40
		}
	end

	continueBtn.x = display.contentWidth*0.5
	continueBtn.y = display.contentHeight - 125

	-- create a confirm button (which will appear if new game is clicked and there is a saved game)
	confirmBtn = widget.newButton{
			label="Erase Saved Game and Continue",
			labelColor = { default={255}, over={128} },
			default="button.png",
			over="button-over.png",
			width=154, height=40,
			onRelease = confirmBtnRelease	-- event listener function
	}

	confirmBtn.x = display.contentWidth*0.5
	confirmBtn.y = display.contentHeight - 250
	confirmBtn.isVisible = false

	
	-- all display objects must be inserted into group
	sceneGroup:insert( background )
	sceneGroup:insert( titleLogo )
	sceneGroup:insert( playBtn )
	sceneGroup:insert( teamInfoBtn )
	sceneGroup:insert( continueBtn )
	sceneGroup:insert( confirmBtn )
end

function scene:show( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if phase == "will" then
		-- Called when the scene is still off screen and is about to move on screen
	elseif phase == "did" then
		-- Called when the scene is now on screen
		-- 
		-- INSERT code here to make the scene come alive
		-- e.g. start timers, begin animation, play audio, etc.
	end	
end

function scene:hide( event )
	local sceneGroup = self.view
	local phase = event.phase
	
	if event.phase == "will" then
		-- Called when the scene is on screen and is about to move off screen
		--
		-- INSERT code here to pause the scene
		-- e.g. stop timers, stop animation, unload sounds, etc.)
	elseif phase == "did" then
		-- Called when the scene is now off screen
	end	
end

function scene:destroy( event )
	local sceneGroup = self.view
	
	-- Called prior to the removal of scene's "view" (sceneGroup)
	-- 
	-- INSERT code here to cleanup the scene
	-- e.g. remove display objects, remove touch listeners, save state, etc.
	
	if playBtn then
		playBtn:removeSelf()	-- widgets must be manually removed
		playBtn = nil
	end
	if teamInfoBtn then
		teamInfoBtn.removeSelf()
		playBtn = nil
	end
	if continueBtn then
		continueBtn.removeSelf()
		continueBtn = nil
	end
	if confirmBtn then
		confirmBtn.removeSelf()
	end
end

---------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene