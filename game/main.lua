--[[
    DONE: animation for the ship
    DONE: scaling and zooming in
    TODO: lightspeed button
]]--
backgroundlayer0 = love.graphics.newImage("assets/layers/backgroundlayer0(5).png")

backgroundlayer1 = love.graphics.newImage("assets/layers/backgroundlayer1(8).png")

backgroundlayer3 = love.graphics.newImage("assets/layers/backgroundlayer3(10).png")

backgroundlayer5 = love.graphics.newImage("assets/layers/backgroundlayer5(still).png")

startbutton = love.graphics.newImage("assets/layers/startbutton.png")

backgroundcolor = love.graphics.newImage("assets/layers/backgroundcolor.png")

asteroid0 = love.graphics.newImage("assets/layers/asteroid(0).png")

PlayAreaWidth = 896
PlayAreaHeight = 414

WindowScaleFactorY = 1
WindowScaleFactorX = 1

shipanimationframe = 0
shipanimation = {}

punch = love.graphics.newImage("assets/layers/punch.png")

asteroid1 = asteroid0

printstatus = "0"
asteroid2 = asteroid0

shipspritesheet = love.graphics.newImage("assets/layers/shipspritesheet.png")



font = love.graphics.newFont("Roboto-Bold.ttf", 25)


Start = "START"

fps = 0



function love.load()

    love.window.setMode(896,414,{vsync = true, fullscreen = true, resizable = true})
    love.graphics.setColor(255,255,255)
    love.graphics.setFont(font)


    


    WindowWidth = love.graphics.getWidth()
    WindowHeight = love.graphics.getHeight()
    
    WindowScaleFactorY = WindowHeight / PlayAreaHeight
    WindowScaleFactorX = WindowWidth / PlayAreaWidth


    --love.window.setFullscreen(true)
    indexforquads = 0
    for yforquad=0,1980,110
    do
        
        indexforquads = indexforquads+1
        shipanimation[indexforquads] = love.graphics.newQuad(0,yforquad,364,110,shipspritesheet:getDimensions())
        
    end

    resetGame()
    

end

width = 0





function love.update(dt)
    
    width = love.graphics.getDimensions()

    if(gamestate == "startmenu")
    then

    else
        fps = love.timer.getFPS( )
        shipy2 = shipy + 74
    
        backgroundlayer0x = backgroundlayer0x - (multiplier/7)
        backgroundlayer1x = backgroundlayer1x - (multiplier/6)
        backgroundlayer2x = backgroundlayer2x - (multiplier/5)
        backgroundlayer3x = backgroundlayer3x - (multiplier/4)
        backgroundlayer5x = backgroundlayer5x - (multiplier/2)
        asteroid1x = asteroid1x - (multiplier/3)
        asteroid2x = asteroid2x - (multiplier/3)
        checkIfBackgroundImagesClipped()
        checkShipCollisionWithAsteroids(asteroid1x,asteroid1y,asteroid0width,asteroid0height)
        
        score = score + dt
        
        

        if(mouseTouchStatus == true)
        then
            if(shipexpectedy > getScaledY(shipy+shipheight))
            then
                shipy = shipy + 1
            else
                if(getScaledY(shipy) >= shipexpectedy)
                then
                    shipy = shipy - 1
                end
                        
            end
        end

        checkIfAsteroidClipped(dt)

        if(activateLightSpeed == true)
        then
            whenLightSpeed(dt)
        end

        if(deactivateLightSpeed == true)
        then
            whenDeactivatingLightSpeed(dt)
        end


        if(shipanimationframe < 18)
        then
            shipanimationframe = shipanimationframe + 1
            shipanimation.image = shipanimation[shipanimationframe]

        else
            shipanimationframe = 1
        end

            
       
        

    end

end





function checkIfAsteroidClipped(dt)

    math.randomseed(dt)
    if(asteroid1x <= -50)
    then 
        asteroid1x = 1792
        asteroid1y = math.random(5,414-50)

    end

    if(asteroid2x <= -50)
    then 
        asteroid2x = 1792
        asteroid2y = math.random(5,414-50)
    end 
end

function checkIfBackgroundImagesClipped()

    if(backgroundlayer0x <= -896) then
        backgroundlayer0x = 0
    end

    if(backgroundlayer1x <= -896) then
        backgroundlayer1x = 0
    end

    if(backgroundlayer3x <= -896) then
        backgroundlayer3x = 0
    end
    

end
function love.touchpressed( id, x, y, dx, dy, pressure )
    -- test if the touch happened in the upper half of the screen
    
 
    
end
    

function love.mousepressed( x, y, button, istouch, presses )
    
    mouseTouchStatus = true
    punchStatusMouse = checkIfClickedOnPunch(x,y)
    if(punchStatusMouse ~= true)
    then
        shipexpectedy = y

    end
    checkIfClickedOnStart(x,y)
end



function love.mousereleased( x, y, button, istouch, presses )

    mouseTouchStatus = false

end

function checkIfClickedOnStart(x, y)
        
    if(x >= getScaledX(startx) and x <= (getScaledX(startx+startwidth)) and  y >= getScaledY(starty) and y <= (getScaledY(starty+startheight)) )
    then
        gamestate = "other"
    end

end

function checkIfClickedOnPunch(x,y)

    if(x >= getScaledX(punchx) and x <= (getScaledX(punchx+50)) and  y >= getScaledY(punchy) and y <= (getScaledY(punchy+50)) )
    then
       

        if(activateLightSpeed == false and gamestate ~= "startmenu" and deactivateLightSpeed == false)
        then
            activateLightSpeed = true
            multiplier = multiplier + 20
            return true   
        else
            return false
        end

    else
        return false
         
    end
end


function whenLightSpeed(dt)
    scalefactor = scalefactor + 0.001
    translatefactory = translatefactory - 0.1
   
    lightSpeedDuration = lightSpeedDuration + dt
    if(lightSpeedDuration >= 3)
    then
        activateLightSpeed = false
        multiplier = 20
        deactivateLightSpeed = true
        lightSpeedDuration = 0
    end
end

function whenDeactivatingLightSpeed(dt)
    scalefactor = scalefactor - 0.001
    translatefactory = translatefactory + 0.1
   
    deactivateLightSpeedDuration = deactivateLightSpeedDuration + dt
    if(deactivateLightSpeedDuration >= 3)
    then
        deactivateLightSpeed = false
        deactivateLightSpeedDuration = 0
    end
    
end



function checkShipCollisionWithAsteroids(secondObjectX, secondObjectY, secondObjectWidth, secondWidthObjectHeight)

    if(getScaledX(shipx) < getScaledX(secondObjectX+secondObjectWidth) and
       getScaledX(shipx+shipwidth) > getScaledX(secondObjectX) and
        getScaledY(shipy) < getScaledY(secondObjectY+secondWidthObjectHeight) and
        getScaledY(shipy + shipheight) > getScaledY(secondObjectY))
    then
        resetGame()
    end

end

function resetGame()
    backgroundlayer0x = 0
    backgroundlayer1x = 0
    backgroundlayer2x = 0
    backgroundlayer3x = 0
    backgroundlayer5x = 0
    scalefactor = 1
    translatefactory = 0
    translatefactorx = 0
    asteroid0width = 30
    asteroid0height = 30
    gamestate = "startmenu"
    asteroid1x = 1792
    asteroid1y = 414/2
    asteroid2x = 1792
    asteroid2y = 414/3
    shipx = 896/6
    shipy = 414/2

    shipx2 = shipx + 182
    shipy2 = shipy + 54
    shipexpectedy = 414/2

    shipwidth = 182
    shipheight = 55

    score = 0
    startwidth = 122
    startheight = 50
    startx = PlayAreaWidth/2 - (122/2)
    starty = PlayAreaHeight/2 - (50/2)
    


    activateLightSpeed = false
    deactivateLightSpeed = false
    lightSpeedDuration = 0
    deactivateLightSpeedDuration = 0
    multiplier = 20

    
    shipanimationframe = 1
    shipanimation.image = shipanimation[1]


    mouseTouchStatus = false

    

    punchx = 20
    punchy = 414-50-20

    

end



function getScaledX(x)
    x = WindowScaleFactorX * x
    return x
end

function getScaledY(y)
    y = WindowScaleFactorY * y
    return y
end



function love.draw()
    love.graphics.scale(WindowScaleFactorX,WindowScaleFactorY)
    if(gamestate == "startmenu")
    then
        love.graphics.draw(backgroundcolor,0,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer0,backgroundlayer0x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer1,backgroundlayer1x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer3,backgroundlayer3x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer5,backgroundlayer5x,0,0,0.5,0.5);
        love.graphics.draw(startbutton,startx,starty,0,0.5,0.5)
       
    else
        love.graphics.scale(scalefactor, scalefactor)
        love.graphics.translate(translatefactorx, translatefactory)
         
        love.graphics.draw(backgroundcolor,0,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer0,backgroundlayer0x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer1,backgroundlayer1x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer3,backgroundlayer3x,0,0,0.5,0.5);
        love.graphics.draw(backgroundlayer5,backgroundlayer5x,0,0,0.5,0.5);
        
        --love.graphics.print(backgroundlayer1x,0,0)

        if(backgroundlayer5x >= -120)
        then
            love.graphics.draw(backgroundlayer5,backgroundlayer5x,0);
        end
        love.graphics.draw(asteroid0,asteroid1x,asteroid1y,0)
        love.graphics.draw(asteroid1,asteroid2x,asteroid2y,90)
        love.graphics.draw(shipspritesheet,shipanimation.image,shipx,shipy,0,0.5,0.5)
        love.graphics.print(PlayAreaHeight,80,20)
        love.graphics.print(WindowHeight,20,20)
        if(activateLightSpeed == false and deactivateLightSpeed == false)
        then
            love.graphics.draw(punch,punchx,punchy,0,0.5,0.5)
        end
    end
    
end