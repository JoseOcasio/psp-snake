local sectimer = 0
local pos = 0
local lg = love.graphics

-- game variables
length = 5
size = 5
snake = {}
direction = "right"
speed = size * 0.2
startPos = {}
startPos.x = 100
startPos.y = 100
food = {}
food.x = 12
food.y = 67
score = 0
-- screenHeight = 0
-- screenWidth = 0
screenHeight = 272
screenWidth = 480

function initGame()
    score = 0
    length = 5
    food.x = 12
    food.y = 67
    direction = "right"
    snake = {}
    for i=1, length do
        tempPos = {}
        tempPos.x = startPos.x - (size * 2) * i
        tempPos.y = startPos.y
        food.x = 12
        food.y = 67
        table.insert(snake, tempPos)
    end
end

function consumeFood()
    -- increment score
    score += 1

    --reposition food
    food.x = math.random(screenWidth - 10)
    food.y = math.random(screenHeight - 10)

    -- increment size of snake
    length += 1
    tempPos = {}
    tempPos.x = startPos.x - (size * 2) * length
    tempPos.y = startPos.y
    table.insert(snake, tempPos)

end

function checkCollision(a, b)
    local a_left = a.x
    local a_right = a.x + size
    local a_top = a.y
    local a_bottom = a.y +size

    local b_left = b.x
    local b_right = b.x + size
    local b_top = b.y
    local b_bottom = b.y + size
    
    if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
        -- collision
        return true
    end

    return false
end

function checkOutOfBounds(a)
    local a_left = a.x
    local a_right = a.x + size
    local a_top = a.y
    local a_bottom = a.y +size

    local b_left = 0
    local b_right = screenWidth + size
    local b_top = 0
    local b_bottom = screenHeight + size
    if a_right > b_left and
    a_left < b_right and
    a_bottom > b_top and
    a_top < b_bottom then
        -- collision
        return true
    else
        return false
    end
end

function checkSelfCollision()
    -- double check; it becomes slow as lenght increases
    for i=#snake, 1, -1 do
        if i >=5 then
            if snake[1].x == snake[i].x and snake[1].y == snake[i].y then
                return true
            end
        end
    end

    return false
end

local lgsetColor = lg.setColor
function lg.setColor(...)
    local args = {...}
    local ver = love.getVersion()
    if ver >= 11 then
        for i = 1, #args do
            if args[i] > 0 then
                args[i] = args[i] / 255
            end
        end
    end
    lgsetColor(args[1],args[2],args[3],args[4])
end

function love.load()
    image = lg.newImage("image.png")
    initGame()
end

function love.draw()
    lg.draw(image, pos, pos)
    lg.setColor(128,128,128,128)
    lg.rectangle("fill",0,0,130,35)
    lg.setColor(255,255,255,255)
    if sectimer <= 1.8 then
        lg.print("score: " .. score,10,10)
    end

    -- snake
    for i=#snake, 1, -1 do
        if i !=1 then
            snake[i].x = snake[i-1].x
            snake[i].y = snake[i-1].y
        else
            if direction == "up" then
                snake[1].y -= speed
            elseif direction == "down" then
                snake[1].y += speed
            elseif direction == "right" then
                snake[1].x += speed
            elseif direction == "left" then
                snake[1].x -= speed
            end
        end
        lg.setColor(255,0,0) --Red
        lg.rectangle("fill", snake[i].x, snake[i].y, size, size )
    end

    -- food
    lg.setColor(0,255,0) --Blue
    lg.rectangle("fill", food.x, food.y, size, size)
end

function love.update(dt)
    sectimer = sectimer + dt
    if sectimer >= 2 then sectimer = 0 end

    pos = pos - 0.625
    if pos <= -200 then
        pos = -50
    end

    --check input
    if love.keyboard.isDown('up') then
        direction = "up"
    elseif love.keyboard.isDown('down') then
        direction = "down"
    elseif love.keyboard.isDown('right') then
        direction = "right"
    elseif love.keyboard.isDown('left') then
        direction = "left"
    end

    if checkCollision(snake[1], food) then
        consumeFood()
    end

    if (not checkOutOfBounds(snake[1])) or checkSelfCollision() then
        initGame()
    end

    
end
