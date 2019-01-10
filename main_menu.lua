-----------------------------------------------------------------------------------------
--
-- main_menu.lua
-- Created by:Soren Drew
-- Date: November 15th 2018
-- Description: This is the main menu, displaying the credits, instructions & play buttons.
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

-- Use Composer Library
local composer = require( "composer" )

-----------------------------------------------------------------------------------------

-- Use Widget Library
local widget = require( "widget" )

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "main_menu"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )


-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

local bkg_image
local playButton
local creditsButton
local instructionsButton

-----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------

local bkgMusic = audio.loadSound("Sounds/MainMenuMusic.mp3")
local bkgMusicChannel

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

-- Creating Transition Function to Credits Page
local function CreditsTransition( )       
    composer.gotoScene( "credits_screen", {effect = "fromLeft", time = 1000})
end 


-- Creating Transition to Level1 Screen
local function Level1ScreenTransition( )
    composer.gotoScene( "level1_screen", {effect = "crossFade", time = 1000})
end  


-- Creating Transition to instuctions Screen
local function InstructionsTransition( )
    composer.gotoScene( "instructions_screen", {effect = "fromLeft", time = 1000})
end 

-- Creating Transition to level select Screen
local function LevelSelectTransition( )
    composer.gotoScene( "levelSelect_screen", {effect = "fromLeft", time = 1000})
end 

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    -----------------------------------------------------------------------------------------
    -- BACKGROUND IMAGE & STATIC OBJECTS
    -----------------------------------------------------------------------------------------

    -- Insert the background image and set it to the center of the screen
    bkg_image = display.newImage("Images/appLogo.png")
    bkg_image.x = display.contentCenterX
    bkg_image.y = display.contentCenterY
    bkg_image.width = display.contentWidth
    bkg_image.height = display.contentHeight


    -- Associating display objects with this scene 
    sceneGroup:insert( bkg_image )

    -----------------------------------------------------------------------------------------
    -- BUTTON WIDGETS
    -----------------------------------------------------------------------------------------   


    playButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = 395,
            y = display.contentHeight*7/8,
            width = 200,
            height = 200,

            -- Insert the images here
            defaultFile = "Images/playButtonUnpressed.png",
            overFile = "Images/playButtonPressed.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = Level1ScreenTransition          
        } )

    -----------------------------------------------------------------------------------------

    -- Creating Credits Button
    creditsButton = widget.newButton( 
        { -- Set its position on the screen relative to the screen size
            x = 170,
            y = display.contentHeight*7/8,
            --create it's width and height
            width = 200,
            height = 200,

            -- Insert the images here
            defaultFile = "Images/creditsButtonUnpressed.png", 
            overFile = "Images/creditsButtonPressed.png", 

            -- When the button is released, call the Credits transition function
            onRelease = CreditsTransition
        }) 
    
    -----------------------------------------------------------------------------------------

     --Creating Instruction Button
    instructionsButton = widget.newButton( 
        {-- Set its position on the screen relative to the screen size
           x = 630,
           y = display.contentHeight*7/8,
            --create it's width and height
            width = 200,
            height = 200,

            -- Insert the images here
            defaultFile = "Images/instructionsButtonUnpressed.png",
            overFile = "Images/instructionsButtonPressed.png",

            -- When the button is released, call the Credits transition function
            onRelease = InstructionsTransition}) 

    -----------------------------------------------------------------------------------------
    --Creating Level Seclect Button
    levelSelect = widget.newButton( 
        {-- Set its position on the screen relative to the screen size
           x = 870,
           y = display.contentHeight*7/8,
            --create it's width and height
            width = 200,
            height = 200,

            -- Insert the images here
            defaultFile = "Images/levelSelectButton.png",
            overFile = "Images/levelSelectButton.png",

            -- When the button is released, call the Credits transition function
            onRelease = LevelSelectTransition}) 

    -----------------------------------------------------------------------------------------

    -- Associating button widgets with this scene
    sceneGroup:insert( playButton )
    sceneGroup:insert( creditsButton )
    sceneGroup:insert( instructionsButton )
    sceneGroup:insert( levelSelect )

end -- function scene:create( event )   



-----------------------------------------------------------------------------------------

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

    -- Called when the scene is now on screen.
    -- Insert code here to make the scene come alive.
    -- Example: start timers, begin animation, play audio, etc.
    elseif ( phase == "did" ) then       
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

end -- function scene:hide( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to be destroyed
function scene:destroy( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view

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
