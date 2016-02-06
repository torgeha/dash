local composer = require( "composer" )
local physics = require("physics")

local scene = composer.newScene()

-- -----------------------------------------------------------------------------------------------------------------
-- All code outside of the listener functions will only be executed ONCE unless "composer.removeScene()" is called.
-- -----------------------------------------------------------------------------------------------------------------

-- local forward references should go here
local ninjaStar
local ninjaX
local ninjaY

local dashDelay = 300
local dashLength = 200

local enenmy

-- swipe variables
local beginX 
local beginY  
local endX  
local endY 
local xDistance  
local yDistance
local bDoingTouch
local minSwipeDistance = 50
local totalSwipeDistanceLeft
local totalSwipeDistanceRight
local totalSwipeDistanceUp
local totalSwipeDistanceDown
-- -------------------------------------------------------------------------------


-- "scene:create()"
function scene:create( event )

    local sceneGroup = self.view

    -- Initialize the scene here.
    -- Example: add display objects to "sceneGroup", add touch listeners, etc.

    local width = display.contentWidth
    local height = display.contentHeight

    print(width)
    print(height)

    physics.start()
    physics.setGravity( 0, 0 ) -- no gravity in any direction

	local background = display.newRect(sceneGroup, width / 2, height / 2, width, height)
	background.fill = {
	    type = 'gradient',
	    color1 = {0.2, 0.45, 0.8},
	    color2 = {0.7, 0.8, 1},
	}

    --physics.addBody( background, "static", { friction=0.5, bounce=0.0 } )

	ninjaStar = display.newImage( "images/ninja_star.png" )
    ninjaX = width / 2
    ninjaY = height / 2
    ninjaStar:scale(0.4,0.4)
	ninjaStar:translate( ninjaX, ninjaY )

    physics.addBody(ninjaStar, {})

    enemy = display.newImage( "images/ninja_star.png" )
    enemy:scale(0.4,0.4)
    enemy:translate( 150, width / 2 )
    physics.addBody(enemy, {})
	
	--setBlur(ninjaStar, "")
	--removeBlur(ninjaStar)

end

function setBlur( image, direction)

	local blurDirection = "filter.blurHorizontal"
	if (direction == "up" or direction == "down") then
		blurDirection = "filter.blurVertical"
	end

    image.fill.effect = blurDirection
    image.fill.effect.blurSize = 30

    timer.performWithDelay(dashDelay - 100, removeBlur)
	
end

function removeBlur()

	
	ninjaStar.fill.effect.blurSize = 0
end


-- "scene:show()"
function scene:show( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is still off screen (but is about to come on screen).
    elseif ( phase == "did" ) then
        -- Called when the scene is now on screen.
        -- Insert code here to make the scene come alive.
        -- Example: start timers, begin animation, play audio, etc.
    end
end


-- "scene:hide()"
function scene:hide( event )

    local sceneGroup = self.view
    local phase = event.phase

    if ( phase == "will" ) then
        -- Called when the scene is on screen (but is about to go off screen).
        -- Insert code here to "pause" the scene.
        -- Example: stop timers, stop animation, stop audio, etc.
    elseif ( phase == "did" ) then
        -- Called immediately after scene goes off screen.
    end
end


-- "scene:destroy()"
function scene:destroy( event )

    local sceneGroup = self.view

    -- Called prior to the removal of scene's view ("sceneGroup").
    -- Insert code here to clean up the scene.
    -- Example: remove display objects, save state, etc.
end


function checkSwipeDirection()
                if bDoingTouch == true then
                xDistance =  math.abs(endX - beginX) -- math.abs will return the absolute, or non-negative value, of a given value. 
                yDistance =  math.abs(endY - beginY)
                if xDistance > yDistance then
                        if beginX > endX then
                        totalSwipeDistanceLeft = beginX - endX
                        if totalSwipeDistanceLeft > minSwipeDistance then
                                print("Swiped Left")

                                ninjaX = ninjaX - dashLength

                                setBlur(ninjaStar, "left")
                                
                                --removeBlur(ninjaStar)


                        end
                    else 
                        totalSwipeDistanceRight = endX - beginX
                        if totalSwipeDistanceRight > minSwipeDistance then
                                print("Swiped Right")
                                setBlur(ninjaStar, "right")
                                ninjaX = ninjaX + dashLength

                                
                        end
                    end
                else 
                 if beginY > endY then
                        totalSwipeDistanceUp = beginY - endY
                        if totalSwipeDistanceUp > minSwipeDistance then
                                print("Swiped Up")
                                setBlur(ninjaStar, "up")
                                ninjaY = ninjaY - dashLength

                                
                        end
                     else 
                        totalSwipeDistanceDown = endY - beginY
                        if totalSwipeDistanceDown > minSwipeDistance then
                                print("Swiped Down")
                                setBlur(ninjaStar, "down")
                                ninjaY = ninjaY + dashLength




                        end
                     end
                end
                transition.to(ninjaStar, {transition=easing.outElastic, x=ninjaX, y=ninjaY, time=dashDelay})
        end
 end
 function swipe(event)
                if event.phase == "began" then
            bDoingTouch = true
                beginX = event.x
            beginY = event.y
        end
        if event.phase == "ended"  then
            endX = event.x
            endY = event.y
            checkSwipeDirection();
            bDoingTouch = false
        end
end
 


-- -------------------------------------------------------------------------------

-- Listener setup
scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
Runtime:addEventListener("touch", swipe)


-- -------------------------------------------------------------------------------

return scene