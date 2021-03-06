-----------------------------------------------------------------------------------------
--
-- levelSelect_screen.lua
-- Created by: Soren Drew
-- Special thanks to Wal Wal for helping in the design of this framework.
-- Date: January 7th 2019
-- Description: This is the level select page, displaying a back button to the main menu.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "levelSelect_screen"

-- Creating Scene Object
scene = composer.newScene( sceneName ) -- This function doesn't accept a string, only a variable containing a string

-----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------

local bkgMusic = audio.loadSound("Sounds/levelSelectSound.mp3")
local bkgMusicChannel

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------
local bkg_image
local backButton
local level1Button
local level2Button
local level3Button

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

-- Creating Transitioning Function back to main menu
local function BackTransition( )
    composer.gotoScene( "main_menu", {effect = "fromLeft", time = 1000})
end

-- Creating Transitioning Function to level 1
local function Level1Transition( )
    composer.gotoScene( "level1_screen", {effect = "crossFade", time = 1000})
end

-- Creating Transitioning Function to level 2
local function Level2Transition( )
    composer.gotoScene( "level2_screen", {effect = "crossFade", time = 1000})
end

-- Creating Transitioning Function to level 3
local function Level3Transition( )
    composer.gotoScene( "level3_screen", {effect = "crossFade", time = 1000})
end


-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------
    -- BACKGROUND AND DISPLAY OBJECTS
    -----------------------------------------------------------------------------------------

    -- Insert the background image and set it to the center of the screen
    bkg_image = display.newImageRect("Images/level3Screen.png", display.contentWidth, display.contentHeight)
    bkg_image.x = display.contentCenterX
    bkg_image.y = display.contentCenterY
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight

    -- Associating display objects with this scene 
    sceneGroup:insert( bkg_image )


    -----------------------------------------------------------------------------------------
    -- BUTTON WIDGETS
    -----------------------------------------------------------------------------------------
    
    backButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = display.contentWidth*1/8,
            y = display.contentHeight*1/8,
            width = 180,
            height = 100,

            -- Insert the images here
            defaultFile = "Images/backButtonUnpressed.png",
            overFile = "Images/backButtonPressed.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = BackTransition       
        } )


    level1Button = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = 200,
            y = 400,
            width = 250,
            height = 290,

            -- Insert the images here
            defaultFile = "Images/level1Button.png",
            overFile = "Images/level1Button.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level1Transition       
        } )


    level2Button = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = 520,
            y = 400,
            width = 250,
            height = 290,

            -- Insert the images here
            defaultFile = "Images/level2Button.png",
            overFile = "Images/level2Button.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level2Transition       
        } )



    level3Button = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = 820,
            y = 400,
            width = 250,
            height = 290,

            -- Insert the images here
            defaultFile = "Images/level3Button.png",
            overFile = "Images/level3Button.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level3Transition       
        } )


 -----------------------------------------------------------------------------------------

    -- Associating Buttons with this scene
    sceneGroup:insert( backButton )
    sceneGroup:insert( level1Button )
    sceneGroup:insert( level2Button )
    sceneGroup:insert( level3Button )
   
end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        --play the background music
        bkgMusicChannel = audio.play(bkgMusic)
    end

end -- function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------

    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        audio.stop (bkgMusicChannel)
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

end --function scene:destroy( event )

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


