_G.love = require("love")

local Collider = require("Collider")
local PhysicsBody = require("PhysicsBody")

solids = {} -- tabela das estruturas sólidas.
local object = {} -- tabela do objeto de teste.
local player = {} -- tabela do player.

local function load_object() -- carregará o objeto.
    object.x = 300 -- posição x do objeto.
    object.y = 200 -- posição y do objeto.
    object.w = 200 -- largura do objeto.
    object.h = 200 -- altura do objeto.

    -- abaixo é criado um colisor para o objeto.
    object.collider = Collider:new(object.x,object.y,object.w,object.h,0,0)

    -- abaixo o objeto é adicionado à tabela "solids".
    table.insert(solids,object.collider)
end

local function draw_object()
    love.graphics.setColor(1,0,0)

    love.graphics.rectangle("fill",
    object.x - object.w/2,
    object.y - object.h/2,
    object.w,object.h)

    love.graphics.setColor(1,1,1)
    object.collider:draw() -- desenha o colisor.
end

local function load_player()
    player.x = 50
    player.y = 200
    player.w = 32
    player.h = 32
    player.speed = 350
    player.vx = 0
    player.vy = 0
    player.visual_offset = 16
    player.body = PhysicsBody:new(player.x,player.y,player.w,player.h,
    player.visual_offset,player.visual_offset)
end

local function player_update(dt) -- update do player.
    if love.keyboard.isDown("a") then
        player.body.vx = -player.speed
        player.body.vy = 0
    elseif love.keyboard.isDown("d") then
        player.body.vx = player.speed
        player.body.vy = 0
    elseif love.keyboard.isDown("w") then
        player.body.vy = -player.speed
        player.body.vx = 0
    elseif love.keyboard.isDown("s") then
        player.body.vy = player.speed
        player.body.vx = 0
    else
        player.body.vx = 0
        player.body.vy = 0
    end
    -- essa a parte da aplicação de gravidade é opcional colocar
    -- se o projeto não precisa de gravidade então ela pode ser apagada.
    --player.body:apply_gravity(dt,0,0)

    -- abaixo tem as atualizações dos movimentos nos vetores
    -- x e depois y.
    -- esse solids é a tabela em que é guardado os objetos
    -- estáticos como chão e paredes.
    player.body:move_x(dt,solids)
    player.body:move_y(dt,solids)
end

local function draw_player()
    local bx,by = player.body:get_center()
    love.graphics.setColor(0,0,1)

    love.graphics.rectangle(
    "fill",
    bx - player.visual_offset,
    by - player.visual_offset,
    player.w, player.h
    )

    love.graphics.setColor(1,1,1)
    player.body:draw() -- desenha o corpo.
    player.body.collider:draw() -- desenha o colisor do corpo.
end

function love.load()
    load_player()
    load_object()
end

function love.update(dt)
    player_update(dt)
end

function love.draw()
    draw_player()
    draw_object()
end