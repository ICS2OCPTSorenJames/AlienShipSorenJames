-----------------------------------------------------------------------------------------
--
-- level1_screen.lua
-- Created by: Soren Drew
-- Description: This is the level 1 screen of the game. the charater can be dragged to move
--If character goes off a certain araea they go back to the start. When a user interactes
--with piant a trivia question will come up. they will have a limided time to click on the answer
-----------------------------------------------------------------------------------------

-----------------------------------------------------------------------------------------
-- INITIALIZATIONS
-----------------------------------------------------------------------------------------

-- Use Composer Libraries
local composer = require( "composer" )
local widget = require( "widget" )
local physics = require( "physics")


-----------------------------------------------------------------------------------------

-- Naming Scene
sceneName = "level2_question"

-----------------------------------------------------------------------------------------

-- Creating Scene Object
local scene = composer.newScene( sceneName )

-----------------------------------------------------------------------------------------
-- LOCAL VARIABLES
-----------------------------------------------------------------------------------------

-- The local variables for this scene
local questionText

local randomOperation
local firstNumber
local secondNumber

local answer
local wrongAnswer1
local wrongAnswer2
local wrongAnswer3

local answerText 
local wrongAnswerText1
local wrongAnswerText2
local wrongAnswerText3

local answerPosition = 1
local bkg
local cover

local X1 = 200
local X2 = 750
local Y1 = 200
local Y2 = 650

local userAnswer
local textTouched = false

local totalSeconds = 20
local secondsLeft = 20
local clockText
local countDownTimer
local questionsAnswered = 0

local circle
local lives = 2
local livesText

-----------------------------------------------------------------------------------------
--SOUNDS
-----------------------------------------------------------------------------------------

--correct sound
local correctSound = audio.loadSound( "Sounds/correctSound.mp3" )
local correctSoundChannel

--incorrect sound
local incorrectSound = audio.loadSound( "Sounds/wrongSound.mp3" )
local incorrectSoundChannel

-----------------------------------------------------------------------------------------
--LOCAL FUNCTIONS
-----------------------------------------------------------------------------------------

--create the game over image 
local function GameOver()
    if (lives == 0) then
        gameOver = display.newImageRect("Images/youLose.png", display.contentWidth, display.contentHeight)
        gameOverSoundChannel = audio.play(gameOverSound)
    end
end


--this function counts down the time
local function UpdateTime()

    --decrement the number of seconds
    secondsLeft = secondsLeft - 1

    --display the number of seconds left in the clock object
    clockText.text = "Time: \n"  ..    secondsLeft

    if (secondsLeft == 0 ) then
        --reset the number of seconds left
        secondsLeft = totalSeconds
        -- decrease life
        lives = lives - 1 
        livesText.text = "lives:" .. lives
        -- call game over or ask another question
        GameOver()
    end       
end

--function that calls the timer
local function StartTimer( event)
    --create a countdown timer that loops infintely
    countDownTimer = timer.performWithDelay( 1000, UpdateTime, 0)
end

function YouWin()
    if (questionsAnswered == 2) then 
        composer.gotoScene( "you_win" )
    end
end

local function ResumeGame()
    composer.hideOverlay("crossFade", 400 )
    questionCircle.isVisible = false 
    RemoveCollisionListenersL2C1()
    ReplaceCharacterL2Q1()
end


-----------------------------------------------------------------------------------------
--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerAnswer(touch)
    userAnswer = answerText.text
    
    if (touch.phase == "ended") then
        correctSoundChannel = audio.play(correctSound)
        questionCircle.isVisible = false
        RemoveCollisionListenersL2C1()
        UpdateTime()

        ResumeGame()
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer(touch)
    userAnswer = wrongText1.text
    
    if (touch.phase == "ended") then
        incorrectSoundChannel = audio.play(incorrectSound)
        RemoveCollisionListenersL2C1()
        lives = lives - 1
        livesText.text = "lives:" .. lives
        UpdateTime()
        ResumeGame()        
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer2(touch)
    userAnswer = wrongText2.text
    
    if (touch.phase == "ended") then
        incorrectSoundChannel = audio.play(incorrectSound)
        lives = lives - 1
        livesText.text = "lives:" .. lives
        RemoveCollisionListenersL2C1()
        UpdateTime()

        ResumeGame()  
    end 
end

--checking to see if the user pressed the right answer and bring them back to level 1
local function TouchListenerWrongAnswer3(touch)
    userAnswer = wrongText3.text
    
    if (touch.phase == "ended") then
        incorrectSoundChannel = audio.play(incorrectSound)
        RemoveCollisionListenersL2C1()
        UpdateTime()
        lives = lives - 1
        livesText.text = "lives:" .. lives

        ResumeGame() 
    end 
end




--adding the event listeners 
local function AddTextListeners()
    answerText:addEventListener( "touch", TouchListenerAnswer )
    wrongText1:addEventListener( "touch", TouchListenerWrongAnswer)
    wrongText2:addEventListener( "touch", TouchListenerWrongAnswer2)
    wrongText3:addEventListener( "touch", TouchListenerWrongAnswer3)
end

--removing the event listeners
local function RemoveTextListeners()
    answerText:removeEventListener( "touch", TouchListenerAnswer )
    wrongText1:removeEventListener( "touch", TouchListenerWrongAnswer)
    wrongText2:removeEventListener( "touch", TouchListenerWrongAnswer2)
    wrongText3:removeEventListener( "touch", TouchListenerWrongAnswer3)
end

local function DisplayQuestion()
    randomOperation = math.random (1,2)

    if ( randomOperation == 1 ) then

        --creating random numbers
        firstNumber = math.random (50,100)
        secondNumber = math.random (50,100)

        -- calculate answer
        answer = firstNumber - secondNumber

        -- calculate wrong answers
        wrongAnswer1 = answer + math.random(1, 3)
        wrongAnswer2 = answer + math.random(4, 6)
        wrongAnswer3 = answer + math.random(7, 10)


        --creating the question depending on the selcetion number
        questionText.text = firstNumber .. " + " .. secondNumber .. " ="

        --creating answer text from list it corispondes with the animals list
        answerText.text = answer
    
        --creating wrong answers
        wrongText1.text = wrongAnswer1
        wrongText2.text = wrongAnswer2
        wrongText3.text = wrongAnswer3

        --start the timer
        StartTimer()

    elseif ( randomOperation == 2 ) then
        --creating random numbers
        firstNumber = math.random (0,10)
        secondNumber = math.random (0,10)

        -- calculate answer
        answer = firstNumber + secondNumber

        -- calculate wrong answers
        wrongAnswer1 = answer - math.random(1, 3)
        wrongAnswer2 = answer - math.random(4, 6)
        wrongAnswer3 = answer - math.random(7, 10)


        --creating the question depending on the selcetion number
        questionText.text = firstNumber .. " - " .. secondNumber .. " ="

        --creating answer text from list it corispondes with the animals list
        answerText.text = answer
    
        --creating wrong answers
        wrongText1.text = wrongAnswer1
        wrongText2.text = wrongAnswer2
        wrongText3.text = wrongAnswer3

        --start the timer
        StartTimer()
    end
end

local function PositionAnswers()

    --creating random start position in a cretain area
    answerPosition = math.random(1,4)

    if (answerPosition == 1) then

        answerText.x = X1
        answerText.y = Y1
        
        wrongText1.x = X2
        wrongText1.y = Y1
        
        wrongText2.x = X1
        wrongText2.y = Y2

        wrongText3.x = X2
        wrongText3.y = Y2

        
    elseif (answerPosition == 2) then

        answerText.x = X1
        answerText.y = Y2
            
        wrongText1.x = X1
        wrongText1.y = Y1
            
        wrongText2.x = X2
        wrongText2.y = Y2

        wrongText3.x = X2
        wrongText3.y = Y1


    elseif (answerPosition == 3) then

        answerText.x = X2
        answerText.y = Y1
            
        wrongText1.x = X1
        wrongText1.y = Y2
            
        wrongText2.x = X1
        wrongText2.y = Y1

        wrongText3.x = X2
        wrongText3.y = Y2

    else 
        answerText.x = X2
        answerText.y = Y2
            
        wrongText1.x = X1
        wrongText1.y = Y2
            
        wrongText2.x = X1
        wrongText2.y = Y1

        wrongText3.x = X2
        wrongText3.y = Y1        
    end
end

-----------------------------------------------------------------------------------------
-- GLOBAL SCENE FUNCTIONS
-----------------------------------------------------------------------------------------

-- The function called when the screen doesn't exist
function scene:create( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view  

    -----------------------------------------------------------------------------------------
    --covering the other scene with a rectangle so it looks faded and stops touch from going through
    bkg = display.newRect(display.contentCenterX, display.contentCenterY, display.contentWidth, display.contentHeight)
    --setting to a semi black colour
    bkg:setFillColor(0,0,0,0.5)

    -----------------------------------------------------------------------------------------
    --making a cover rectangle to have the background fully bolcked where the question is
    cover = display.newRoundedRect(display.contentCenterX, display.contentCenterY, display.contentWidth*0.8, display.contentHeight*0.95, 50 )
    --setting its colour
    cover:setFillColor(96/255, 96/255, 96/255)

    -- create the question text object
    questionText = display.newText("", display.contentCenterX, display.contentCenterY*3/8, Arial, 75)

    -- create the answer text object & wrong answer text objects
    answerText = display.newText("", X1, Y2, Arial, 75)
    answerText.anchorX = 0

    wrongText1 = display.newText("", X2, Y2, Arial, 75)
    wrongText1.anchorX = 0

    wrongText2 = display.newText("", X1, Y1, Arial, 75)
    wrongText2.anchorX = 0

    wrongText3 = display.newText("", X2, Y1, Arial, 75)
    wrongText3.anchorX = 0

    --create the timer
    clockText = display.newText ("Time: \n"  ..  secondsLeft, 500, 450, nil, 50)
    clockText:setTextColor(168/255, 13/255, 13/255)

    --insert the circle
    circle = display.newImageRect("Images/circle.png", 100, 100)
    circle.x = 350
    circle.y = display.contentHeight * 2.08
    circle.isVisible = false


    questionCircle = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle.x = 350
    questionCircle.y = 650
    questionCircle.myName = "questionCircle"
    questionCircle:toBack()
    sceneGroup:insert( questionCircle )
    
    

    questionCircle2 = display.newImageRect("Images/circle.png", 100, 100)
    questionCircle2.x = 650
    questionCircle2.y = 650
    questionCircle2.myName = "questionCircle2"
    questionCircle2:toBack()
    sceneGroup:insert( questionCircle2 )


    livesText = display.newText("lives:" .. lives, 100, 100, nil, 50)
    livesText:setTextColor(1, 1, 1)
    livesText.x = 100
    livesText.y = 60

    -----------------------------------------------------------------------------------------

    -- insert all objects for this scene into the scene group
    sceneGroup:insert(bkg)
    sceneGroup:insert(cover)
    sceneGroup:insert(questionText)
    sceneGroup:insert(answerText)
    sceneGroup:insert(wrongText1)
    sceneGroup:insert(wrongText2)
    sceneGroup:insert(wrongText3)
    sceneGroup:insert( clockText )

end --function scene:create( event )

-----------------------------------------------------------------------------------------

-- The function called when the scene is issued to appear on screen
function scene:show( event )

    -- Creating a group that associates objects with the scene
    local sceneGroup = self.view
    local phase = event.phase

    -----------------------------------------------------------------------------------------

    if ( phase == "will" ) then

        -- Called when the scene is still off screen (but is about to come on screen).
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
        DisplayQuestion()
        PositionAnswers()
        AddTextListeners()
        AddCollisionListenersL2C1()
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
        --parent:resumeGame()
    -----------------------------------------------------------------------------------------

    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
        RemoveTextListeners()
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