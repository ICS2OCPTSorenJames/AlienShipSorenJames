-----------------------------------------------------------------------------------------
-- Title: Company Logo Animation
-- Name: James Lyall
-- Course: ICS2O
-- This program displays the company logo for the game
-----------------------------------------------------------------------------------------


-- Use Composer Library
local composer = require( "composer" )

-- Name the Scene
sceneName = "splash_screen"

-----------------------------------------------------------------------------------------

-- Hide the status bar.
display.setStatusBar(display.HiddenStatusBar)

-- Create Scene Object
local scene = composer.newScene( sceneName )

----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------
 
local backgroundSound = audio.loadSound("Sounds/AppLogoScreen.mp3")
local backgroundSoundChannel

local CometSound = audio.loadSound( "Sounds/swoosh2.mp3" )
local CometSoundChannel

----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------
 
-- The local variables for this scene
local CompanyLogo
local Comet
local Comet2
local scrollSpeed = -5

--------------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
--------------------------------------------------------------------------------------------

--function: MoveComet
    --Input: this function accepts an event listener
    --Output: none
-- Description: This function adds the scroll speed to the x-value of the ship
local function MoveComet(event)
    -- add the scroll speed to the x-value of the ship
   Comet.y = Comet.y - scrollSpeed
   Comet.x = Comet.x + scrollSpeed
    -- make car opacity fade out
   Comet.alpha = Comet.alpha - 0.001
    CompanyLogo.alpha = CompanyLogo.alpha - 0.001
end
    


-- function: MoveComet
-- Input: this function accepts an event listener
-- Output: none
-- Description: This function adds the scroll speed to the x-value of the comet
local function MoveComet2(event)
    -- add the scroll speed to the x-value of the comet
    Comet2.y = Comet2.y - scrollSpeed
    Comet2.x = Comet2.x - scrollSpeed
    -- make car opacity fade out
    Comet2.alpha = Comet2.alpha - 0.001
end
    



-- The function that will go to the main menu 
local function gotoMainMenu()
    composer.gotoScene( "main_menu" )
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -- create the background image
    CompanyLogo = display.newImageRect("Images/CompanyLogo.png", 1024, 768)
    

    Comet = display.newImageRect("Images/Comet.png", 250, 250)
    Comet2 = display.newImageRect("Images/Comet.png", 250, 250)

    Comet.x = 925
    Comet.y = 0

    Comet2.x = 100
    Comet2.y = 0


    CompanyLogo.x = display.contentCenterX
    CompanyLogo.y = display.contentCenterY

    -- rotate the second comet so it faces dowm

    Comet2:rotate(260)


    -- set images transparent
    CompanyLogo.alpha = 1

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( CompanyLogo )
    sceneGroup:insert( Comet )
    sceneGroup:insert( Comet2 )



end -- function scene:create( event )



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
        --play the sound
        CometSoundChannel = audio.play(CometSound)

        -- Go to the main menu screen after the given time.
        timer.performWithDelay ( 3000, gotoMainMenu)   
        
        -- MoveComet will be called over and over again
        Runtime:addEventListener("enterFrame", MoveComet)  

        -- MoveComet will be called over and over again
        Runtime:addEventListener("enterFrame", MoveComet2)     
        
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
        --stop the audio
       audio.stop(CometSoundChannel)
       Runtime:removeEventListener("enterFrame", MoveComet) 
       Runtime:removeEventListener("enterFrame", MoveComet2)
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