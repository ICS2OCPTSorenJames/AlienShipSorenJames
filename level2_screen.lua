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

-- start physics
physics.start()

-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level2_screen"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- GLOBAL VARIABLES
-----------------------------------------------------------------------------------------

lives = 2

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

--the local variables for this scene
local background

local questionCircle
local questionCircle2
local backButton

local questionsAnswered = 0

local circle
local portal

local character

local rArrow 
local uArrow
local lArrow

local motionx = 0
local SPEED = 3
local LINEAR_VELOCITY = -100
local GRAVITY = 8

local correctText
local incorrectText


local livesText

local floor
local floor2
local floor3
local ceiling
local rWall

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

local function MakeCirclesVisible()
    questionCircle.isVisible = true
    questionCircle2.isVisible = true
    portal.isVisible = true
end


local function YouLose()
    if (lives == 0) then 
        composer.gotoScene( "you_lose" )
    end
end


function AddArrowEventListeners()
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
            --display.remove(character)

            -- stop the character from moving
            motionx = 0

            -- make the character invisible
            character.isVisible = false

            -- show overlay with math question
            composer.showOverlay( "level2_question", { isModal = true, effect = "fade", time = 100})

            -- Increment questions answered

            questionsAnswered = questionsAnswered + 1    
        end
    end
end

local function onCollisionPortal( self, event )
    -- for testing purposes
    --print( event.target )        --the first object in the collision
    --print( event.other )         --the second object in the collision
    --print( event.selfElement )   --the element (number) of the first object which was hit in the collision
    --print( event.otherElement )  --the element (number) of the second object which was hit in the collision
    --print( event.target.myName .. ": collision began with " .. event.other.myName )

    if ( event.phase == "began" ) then

        if  (event.target.myName == "portal") then 

            -- get the circle that the user hit
            circle = event.target 


            -- remove runtime listeners that move the character
            RemoveArrowEventListeners()
            RemoveRuntimeListeners()

            -- remove the character from the display
            --display.remove(character)

            -- stop the character from moving
            motionx = 0

            -- make the character invisible
            character.isVisible = false
            

            -- show overlay with math question
            composer.gotoScene("level3_screen")  
        end
    end
end


local function ReplaceCircles()
    --create the circle
    questionCircle = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle.x = 350
    questionCircle.y = 650
    questionCircle.myName = "questionCircle"
    

    --create the second circle
    questionCircle2 = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle2.x = 650
    questionCircle2.y = 650
    questionCircle2.myName = "questionCircle2"
end

local function RemoveCircles()
    --display.remove(questionCircle)
    --display.remove(questionCircle2)
    --display.remove(portal)
end

local function ReplaceCharacterL2()
    character = display.newImageRect("Images/Character1.png", 100, 150)
    character.x = 100

    character.y = 20
    character.width = 150
    character.height = 150

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

local function AddPhysicsBodies()
    --add to the physics engine
    physics.addBody (questionCircle, "static", {density=0, friction=0, bounce=0} )
    physics.addBody (questionCircle2, "static", {density=0, friction=0, bounce=0} )
    physics.addBody (portal, "static", {density=0, friction=0, bounce=0} )
    physics.addBody(floor, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(floor2, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(floor3, "static", {density=1, friction=0.3, bounce=0.2} )
    physics.addBody(ceiling, "static", {friction=0.5, bounce=0.3})
    physics.addBody(rWall, "static", {friction=0.5, bounce=0.3})
end

local function RemovePhysicsBodies()
    physics.removeBody(questionCircle)
    physics.removeBody(questionCircle2)
    physics.removeBody(portal)
    physics.removeBody(floor)
    physics.removeBody(floor2)
    physics.removeBody(floor3)
    physics.removeBody(ceiling)
    physics.removeBody(rWall)
end

--add collision to the first circle
function AddCollisionListeners()
    --if they hit the circle on collision will be called
    questionCircle.collision = onCollision
    questionCircle:addEventListener( "collision" )
    questionCircle2.collision = onCollision
    questionCircle2:addEventListener( "collision" )
    portal.collision = onCollisionPortal
    portal:addEventListener( "collision" )
end

--remove collision to the first circle
function RemoveCollisionListeners()
    questionCircle:removeEventListener( "collision" )
    questionCircle2:removeEventListener( "collision" )
    portal:removeEventListener( "collision" )
end

-- Creating Transitioning Function back to main menu
local function BackTransition( )
    composer.gotoScene( "main_menu", {effect = "fromLeft", time = 1000})
end


-----------------------------------------------------------------------------------------
-- GLOBAL FUNCTIONS
-----------------------------------------------------------------------------------------

function ResumeLevel2()

    character.isVisible = true

    --character.x = 510
    --character.y = 650


    print ("***lives = " .. lives)

    livesText.text = "Lives: " .. lives
    AddRuntimeListeners()
    AddArrowEventListeners()

    if (questionsAnswered > 0) then
        if (circle ~= nil) and (circle.isBodyActive == true) then
            physics.removeBody(circle)
            circle.isVisible = false  
        end
    end
    
    if (lives == 0) then
        YouLose()
    end
end

function ResumeLevel2Q2()

    character.isVisible = true
    character.x = 750
    character.y = 650

    livesText.text = "Lives: " .. lives
    AddRuntimeListeners()
    AddArrowEventListeners()
    RemoveCollisionListeners()

    if (questionsAnswered > 0) then
        if (circle ~= nil) and (circle.isBodyActive == true) then
            physics.removeBody(circle)
            circle.isVisible = false  
        end
    end
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

--this fuction is called when the scene doesn't exist
function scene:create( event )


    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view    

    -- Insert the background image
    background = display.newImageRect("Images/Level2Screen.png", display.contentWidth, display.contentHeight)
    background.x = display.contentWidth / 2 
    background.y = display.contentHeight / 2   

    sceneGroup:insert( background )

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

            motionx = 0,

            -- When the button is released, call the Level1 screen transition function
            onRelease = BackTransition       
        } )

    sceneGroup:insert( backButton )

    character = display.newImageRect("Images/Character1.png", 100, 150)
    character.x = 700
    character.y = 700
    character.width = 100
    character.height = 150
    character.myName = "KickyKat"
    character.isVisible = false

    sceneGroup:insert( character ) 

    livesText = display.newText("Lives: " .. lives, 100, 100, nil, 50)
    livesText:setTextColor(1, 1, 1)
    livesText.x = 100
    livesText.y = 60
    sceneGroup:insert( livesText ) 

    --Insert the right arrow
    rArrow = display.newImageRect("Images/RightArrowUnpressed.png", 100, 50)
    rArrow.x = display.contentWidth * 9.7 / 10
    rArrow.y = 680
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rArrow)

    -- add the portal circle
    portal = display.newImageRect("Images/Portal.png", 130, 130)
    portal.x = display.contentWidth * 9 / 10
    portal.y = 500
    portal.myName = "portal"

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( portal )

    --Insert the right arrow
    lArrow = display.newImageRect("Images/LeftArrowUnpressed.png", 100, 50)
    lArrow.x = display.contentWidth * 7.7 / 10
    lArrow.y = 680

 
   
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( lArrow )

    --Insert the left arrow
    uArrow = display.newImageRect("Images/UpArrowUnpressed.png", 50, 100)
    uArrow.x = display.contentWidth * 8.7 / 10
    uArrow.y = display.contentHeight * 8.5 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( uArrow )

    --Insert the floor
    floor = display.newImageRect("Images/Level-1Floor.png", 190, 10)
    floor.x = display.contentWidth * 4.5 / 10
    floor.y = 325

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    --Insert the floor
    floor2 = display.newImageRect("Images/Level-1Floor.png", 190, 10)
    floor2.x = display.contentWidth * 1 / 10
    floor2.y = display.contentHeight * 3.5 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor2 )

    --Insert the floor
    floor3 = display.newImageRect("Images/Level-1Floor.png", 150, 10)
    floor3.x = display.contentWidth * 6.5 / 10
    floor3.y = display.contentHeight *  2.7 / 10

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor3 )

    --Insert the ceiling
    ceiling = display.newImageRect("Images/Level-1Floor.png", 1024, 1)
    ceiling.x = display.contentCenterX
    ceiling.y = 5    
    ceiling.isVisible = false

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( ceiling )

    --Insert the right wall
    rWall = display.newImageRect("Images/Rwall.png", 10, 1024)
    rWall.x = 1000
    rWall.y = display.contentCenterY
    rWall.isVisible = false

    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( rWall )

    --create the circle
    questionCircle = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle.x = 500
    questionCircle.y = 275
    questionCircle.myName = "questionCircle"
    
    sceneGroup:insert( questionCircle )

    --create the second circle
    questionCircle2 = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle2.x = 660
    questionCircle2.y = 150
    questionCircle2.myName = "questionCircle2"

    sceneGroup:insert( questionCircle2 )  
    
end


----------------------------------------------------------------------------------------

    
    -- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    --associates the back butto to only be in this scene
    
    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    
        -- start physics
        physics.start()

        -- set gravity
        physics.setGravity( 0, GRAVITY )

    elseif ( phase == "did" ) then

        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.

        lives = 2
        questionsAnswered = 0



        -- add physics bodies to each object
        AddPhysicsBodies()

        -- add collision listeners to objects
        AddCollisionListeners()

        -- create the character, add physics bodies and runtime listeners
        ReplaceCharacterL2()
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
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.    
        RemovePhysicsBodies()
        display.remove(character)
        RemoveCircles()

        RemoveArrowEventListeners()
        RemoveRuntimeListeners()
        physics.stop()

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