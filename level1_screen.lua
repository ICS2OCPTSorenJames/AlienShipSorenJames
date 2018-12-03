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

--the local variables for this scene
local background

local questionCircle
local questionCircle2

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

local totalSeconds = 10
local secondsLeft = 10
local clockText
local countDownTimer

local lives = 3
local heart1
local heart2
local heart3

local floor

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

if ( event.phase == "began" ) then 

	(event.target.myName == "questionCircle") or
            (event.target.myName == "questionCircle2") then
            

            -- get the ball that the user hit
            theBall = event.target

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

    -- Insert the background image
    background = display.newImageRect("Images/Level1Screen.png", display.contentWidth, display.contentHeight)
    background.x = display.contentWidth / 2 
    background.y = display.contentHeight / 2

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
    floor.y = display.contentHeight * 1.06
    
    -- Insert objects into the scene group in order to ONLY be associated with this scene
    sceneGroup:insert( floor )

    questionCircle = display.newImageRect("Images/circle.png", 200, 200)
    questionCircle.x = 
    questionCircle.y = 

    sceneGroup:insert( questionCircle )

    questionCircle2 = display.newImageRect("Images/circle.png", 200, 200)
    questionCircle2.x = 
    questionCircle2.y = 

    sceneGroup:insert( questionCircle2 )
    