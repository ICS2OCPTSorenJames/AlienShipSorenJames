-----------------------------------------------------------------------------------------
--
-- splash_screen.lua
-- Created by: Soren Drew
-- Date: November 12th 2018
-- Description: This is the splash screen of the game. It displays the 
-- company logo that...
-----------------------------------------------------------------------------------------

-- Use Composer Library
local composer = require( "composer" )

-- Name the Scene
sceneName = "splash_screen"

-----------------------------------------------------------------------------------------

-- Create Scene Object
local scene = composer.newScene( splash_screen )

----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------
 
-- The local variables for this scene
local FlossBoss
local FlossBoss2
local comet1
local comet2
local scrollSpeedComet1 = 6
local scrollSpeedComet2 = 6

FlossBoss = display.newImageRect("Images/CompanyLogoSoren.png", 600, 600)
FlossBoss2 = display.newImageRect("Images/CompanyLogoGlow.png", 600, 600)
    
comet1 = display.newImageRect("Images/comet.png", 150, 150)
comet2 = display.newImageRect("Images/comet.png", 150, 150)

comet1.x = 0
comet1.y = 450

comet2.x = 1024
comet2.y = 150

FlossBoss.isVisible = true
FlossBoss2.isVisible = false
----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------
 
local swooshSound1 = audio.loadSound("Sounds/booSound.mp3")
local swooshSoundChannel1

local swooshSound2 = audio.loadSound("Sounds/booSound.mp3")
local swooshSoundChannel2


-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- create the background image
    local background = display.newImageRect("Images/background.jfif", 2048, 1536)

    --put the background in the back layer
    background:toBack()

    -- set the initial x and y position of the flossBosses
    FlossBoss.x = 570
    FlossBoss.y = 350

    FlossBoss2.x = 570
    FlossBoss2.y = 350

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( FlossBoss )

end -- function scene:create( event )

--------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

-- The function moves the first comet across the screen
local function moveComet1(event)
    comet1.x = comet1.x + scrollSpeedComet1
    comet1.y = comet1.y - scrollSpeedComet1
    --play the sound
    swooshSoundChannel1 = audio.play(swooshSound1)
    --change the image and stop the sound
    if (comet1.y == 0) then 
        FlossBoss.isVisible = false
        FlossBoss2.isVisible = true
        audio.pause(swooshSoundChannel1)
    end
end

-- The function moves the second comet across the screen
local function moveComet2(event)
    comet2.x = comet2.x - scrollSpeedComet2
    comet2.y = comet2.y + scrollSpeedComet2
    --play the sound after a delay
    swooshSoundChannel2 = audio.play(swooshSound2)
    timer.performWithDelay(500, swooshSoundChannel2)
    --stop the sound once it is off the screen
    if (comet2.y == 500 ) then
        audio.pause(swooshSoundChannel2)
    end
end


-- The function that will go to the main menu 
local function gotoMainMenu()
    composer.gotoScene( "main_menu" )
end

--------------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is still off screen (but is about to come on screen).
    if ( phase == "will" ) then
       
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Call the movecomet1 and movecomet2 function as soon as we enter the frame.
        Runtime:addEventListener("enterFrame", moveComet1)
        Runtime:addEventListener("enterFrame", moveComet2)

        -- Go to the main menu screen after the given time.
        timer.performWithDelay ( 3000, gotoMainMenu)          
        
    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    -- Called when the scene is on screen (but is about to go off screen).
    -- Insert code here to "pause" the scene.
    -- Example: stop timers, stop animation, stop audio, etc.
    if ( phase == "will" ) then  

    -----------------------------------------------------------------------------------------

    -- Called immediately after scene goes off screen.
    elseif ( phase == "did" ) then
        --make the logo invisible after the animation is finished
        FlossBoss.isVisible = false
        FlossBoss2.isVisible = false  
        comet2.isVisible = false 
        --stop the audio
       --audio.stop(swooshSoundChannel2)
       --audio.stop(swooshSoundChannel1)
    end

end --function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------


    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end -- function scene:destroy( event )

-----------------------------------------------------------------------------------------
-- EVENT LISTENERS
-----------------------------------------------------------------------------------------

-- Adding Event Listeners
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

-----------------------------------------------------------------------------------------

return scene
