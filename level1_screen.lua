-----------------------------------------------------------------------------------------
--
-- main.lua
--Name:Soren Drew
--Date: November 30th 2018
--Course:ICS20/3C


-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )

-- load physics
local physics = require("physics")

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level1_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

--start physics
physics.start()

--the local variables for this scene
local background

local questionCircle
local questionCircle2
local backButton
local questionsAnswered
local circle
local circle2

local chracter

local rArrow 
local uArrow
local lArrow

local motionx = 0
local SPEED = 3
local LINEAR_VELOCITY = -100
local GRAVITY = 8

local correctText
local incorrectText

local lives = 3
local heart1
local heart2
local heart3

local floor

-----------------------------------------------------------------------------------------
-- SOUNDS
-----------------------------------------------------------------------------------------

local gameOverSound = audio.loadSound( "Sounds/booSound.mp3" )
local gameOverSoundChannel

-----------------------------------------------------------------------------------------
-- LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------


-- When right arrow is touched, move character right
local function right (touch)
    motionx = SPEED
    character.xScale = 1
end

-- When left arrow is touched, move character left
local function left (touch)
    motionx = -SPEED
    character.xScale = -1
end

-- When up arrow is touched, add vertical so it can jump
local function up (touch)
    if (character ~= nil) then
        character:setLinearVelocity( 0, LINEAR_VELOCITY )
    end
end

-- Move character horizontally
local function movePlayer (event)
    character.x = character.x + motionx
end
 
-- Stop character movement when no arrow is pushed
local function stop (event)
    if (event.phase =="ended") then
        motionx = 0
    end
end

--create the game over image 
local function GameOver()
    if (lives == 0) then
        heart3.isVisible = false
        heart2.isVisible = false
        heart1.isVisible = false
        gameOver = display.newImageRect("Images/gameOver.png", 2048, 1536)
        gameOverSoundChannel = audio.play(gameOverSound)
    end
end

--update the visibility of the hearts
local function UpdateHearts()

    if (lives == 2 ) then 
        heart3.isVisible = false
    elseif (lives == 1) then
        heart2.isVisible = false
    elseif (lives == 0) then
    GameOver()
    end
end


local function AddArrowEventListeners()
    rArrow:addEventListener("touch", right)
    uArrow:addEventListener("touch", up)
    lArrow:addEventListener("touch", left)
end

local function RemoveArrowEventListeners()
    rArrow:removeEventListener("touch", right)
    uArrow:removeEventListener("touch", up)
    lArrow:removeEventListener("touch", left)
end

local function AddRuntimeListeners()
    Runtime:addEventListener("enterFrame", movePlayer)
    Runtime:addEventListener("touch", stop )
end

local function RemoveRuntimeListeners()
    Runtime:removeEventListener("enterFrame", movePlayer)
    Runtime:removeEventListener("touch", stop )
end

local function ReplaceCharacter()
    character = display.newImageRect("Images/KickyKatRight.png", 100, 150)
    character.x = display.contentWidth * 0.5 / 8
    character.y = display.contentHeight  * 0.1 / 3
    character.width = 75
    character.height = 100
    character.myName = "KickyKat"

    -- intialize horizontal movement of character
    motionx = 0

    -- add physics body
    physics.addBody( character, "dynamic", { density=0, friction=0.5, bounce=0, rotation=0 } )

    -- prevent character from being able to tip over
    character.isFixedRotation = true

    -- add back arrow listeners
    AddArrowEventListeners()

    -- add back runtime listeners
    AddRuntimeListeners()
end


local function onCollision( self, event )
    -- for testing purposes
    --print( event.target )        --the first object in the collision
    --print( event.other )         --the second object in the collision
    --print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    --print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    --print( event.target.myName .. ": collision began with " .. event.other.myName )

    if ( event.phase == "began" ) then

        if  (event.target.myName == "questionCircle") or 
            (event.target.myName == "questionCircle2") then

            -- get the ball that the user hit
            circle = event.target  

            -- remove runtime listeners that move the character
            RemoveArrowEventListeners()
            RemoveRuntimeListeners()

            -- remove the character from the display
            display.remove(character)

            -- stop the character from moving
            motionx = 0

            -- make the character invisible
            character.isVisible = false

            -- show overlay with math question
            composer.showOverlay( "level1_question", { isModal = true, effect = "fade", time = 100})

            -- Increment questions answered
            questionsAnswered = questionsAnswered + 1
        end      
    end
end


local function ReplaceCharacter()
    character = display.newImageRect("Images/KickyKatRight.png", 100, 150)
    character.x = 100
    character.y = 650
    character.width = 75
    character.height = 100
    character.myName = "KickyKat"

    -- intialize horizontal movement of character
    motionx = 0

    -- add physics body
    physics.addBody( character, "dynamic", { density=0, friction=0.5, bounce=0, rotation=0 } )

    -- prevent character from being able to tip over
    character.isFixedRotation = true

    -- add back arrow listeners
    AddArrowEventListeners()

    -- add back runtime listeners
    AddRuntimeListeners()
end


-- Creating Transitioning Function back to main menu
local function BackTransition( )
    composer.gotoScene( "main_menu", {effect = "fromLeft", time = 1000})
end


local function ResumeGame()

    -- make character visible again
    character.isVisible = true
    
    if (questionsAnswered > 0) then
        if (circle ~= nil) and (circle.isBodyActive == true) then
            physics.removeBody(circle)
            circle.isVisible = false
        end
    end
end


local function AddCollisionListeners()
	--if they hit the circle on collision will be called
	questionCircle.collision = onCollision
    questionCircle:addEventListener( "collision" )
    questionCircle2.collision = onCollision
    questionCircle2:addEventListener( "collision" )
end

local function RemoveCollisionListeners()
	questionCircle:removeEventListener( "collision" )
    questionCircle2:removeEventListener( "collision" )
end

local function AddPhysicsBodies()
	--add to the physics engine
	physics.addBody (questionCircle, "static", {density=0, friction=0, bounce=0} )
	physics.addBody (questionCircle2, "static", {density=0, friction=0, bounce=0} )
	physics.addBody(floor, "static", {density=1, friction=0.3, bounce=0.2} )
end

local function RemovePhysicsBodies()
	physics.removeBody(questionCircle)
	physics.removeBody(questionCircle2)
	physics.removeBody(floor)
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

--this fuction is called when the scene doesn't exist
function scene:create( event )

	-- Creating a group that associates objects with the scene
    local sceneGroup = self.view

    --create the back button
    backButton = widget.newButton( 
        {   
            -- Set its position on the screen relative to the screen size
            x = 850,
            y = display.contentHeight*1/8,
            width = 180,
            height = 100,

            -- Insert the images here
            defaultFile = "Images/backButtonUnpressed.png",
            overFile = "Images/backButtonPressed.png",

            -- When the button is released, call the Level1 screen transition function
            onRelease = BackTransition       
        } )

    sceneGroup:insert( backButton )

    -- Insert the background image
    background = display.newImageRect("Images/Level1Screen.png", display.contentWidth, display.contentHeight)
    background.x = display.contentWidth / 2 
    background.y = display.contentHeight / 2
    background:toBack()

    sceneGroup:insert( background )

    -- Insert the Hearts
    heart1 = display.newImageRect("Images/heart.png", 80, 80)
    heart1.x = 50
    heart1.y = 50
    heart1.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart1 )

    -- Insert the Hearts
    heart2 = display.newImageRect("Images/heart.png", 80, 80)
    heart2.x = 130
    heart2.y = 50
    heart2.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart2 )

    -- Insert the Hearts
    heart3 = display.newImageRect("Images/heart.png", 80, 80)
    heart3.x = 210
    heart3.y = 50
    heart3.isVisible = true

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( heart3 )

    --Insert the right arrow
    rArrow = display.newImageRect("Images/RightArrowUnpressed.png", 100, 50)
    rArrow.x = display.contentWidth * 9.2 / 10
    rArrow.y = display.contentHeight * 9.5 / 10
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rArrow)

    --Insert the right arrow
    lArrow = display.newImageRect("Images/LeftArrowUnpressed.png", 100, 50)
    lArrow.x = display.contentWidth * 7.2 / 10
    lArrow.y = display.contentHeight * 9.5 / 10
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( lArrow)

    --Insert the left arrow
    uArrow = display.newImageRect("Images/UpArrowUnpressed.png", 50, 100)
    uArrow.x = display.contentWidth * 8.2 / 10
    uArrow.y = display.contentHeight * 8.5 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( uArrow)

    --Insert the floor
    floor = display.newImageRect("Images/Level-1Floor.png", 1024, 100)
    floor.x = display.contentCenterX
    floor.y = 750
    physics.addBody(floor, "static", {friction=0.5, bounce=0.3})

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    --create the circle
    circle = display.newImageRect("Images/circle.png", 100, 100)
    circle.x = 350
    circle.y = 650
    circle.isVisible = false

    
    --create the second circle
    circle2 = display.newImageRect("Images/circle.png", 100, 100)
    circle2.x = 650
    circle2.y = 650
    circle2.isVisible = false    

    questionCircle = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle.x = 350
    questionCircle.y = 650
    questionCircle.isVisible = true
    questionCircle.myName = "questionCircle"
    --questionCircle:toBack()

    sceneGroup:insert( questionCircle )

    questionCircle2 = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle2.x = 650
    questionCircle2.y = 650
    questionCircle2.isVisible = true
    questionCircle2.myName = "questionCircle2"
    --questionCircle2:toBack()

    sceneGroup:insert( questionCircle2 )

    --create the character 
    --[[character = display.newImageRect("Images/KickyKatRight.png", 200, 200)
    character.x = 100
    character.y = 650

    sceneGroup:insert( character )]]

    
end

----------------------------------------------------------------------------------------

    
    -- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    --associates the back butto to only be in this scene
    sceneGroup:insert( backButton ) 
    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        ReplaceCharacter()

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

    end

end --function scene:show( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to leave the screen
function scene:hide( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.

    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
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


--[[ decrease number of lives
 numLives = numLives - 1

            if (numLives == 2 ) then
                -- update hearts
                heart1.isVisible = true
                heart2.isVisible = true
                heart3.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter) 

            elseif (numLives == 1 ) then
              -- update hearts
                heart1.isVisible = true
                heart2.isVisible = false
                heart3.isVisible = false
                timer.performWithDelay(200, ReplaceCharacter)    

            elseif (numLives == 0) then
                -- update hearts
                heart1.isVisible = false
                heart2.isVisible = false
                heart3.isVisible = false
                timer.performWithDelay(200, YouLoseTransition)
            end--]]