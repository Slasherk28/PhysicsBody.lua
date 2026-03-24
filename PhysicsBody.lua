local PhysicsBody = {}
PhysicsBody.__index = PhysicsBody
local Collider = require("Collider")

function PhysicsBody:new(x,y,w,h,ox,oy)
    local b = {
        x = x or 0,
        y = y or 0,
        w = w or 0,
        h = h or 0,
        vx = 0,
        vy = 0,
        ox = ox or 0,
        oy = oy or 0,
        collider = Collider:new(x,y,w,h,ox,oy),
        on_ground = false
    }
    setmetatable(b, PhysicsBody)
    return b
end

-- cria o centro para o corpo.
function PhysicsBody:get_center()
    local cx = self.x + self.w/2
    local cy = self.y + self.h/2
    return cx,cy
end

function PhysicsBody:move_x(dt, solids)
    self.x = self.x + self.vx * dt
    -- atualiza a posição do colisor do corpo.
    self.collider:update(self.x,self.y)

    for _, solid in ipairs(solids) do
        if self.collider:intersects(solid) then
            if self.vx > 0 then
                -- bateu pela direita.
                self.collider.x = solid.x - solid.w/2 - self.collider.w/2
                self.vx = 0
            elseif self.vx < 0 then
                -- bateu pela esquerda.
                self.collider.x = solid.x + solid.w/2 + self.collider.w/2
                self.vx = 0
            end
            self.x = self.collider.x - self.collider.ox
            self.vx = 0
            break
        end
    end
end

function PhysicsBody:move_y(dt, solids)
    local dy = self.vy * dt
    dy = math.max(-16, math.min(16, dy)) -- limite por frame.

    self.y = self.y + dy
    self.collider:update(self.x,self.y)
    self.on_ground = false
    for _, solid in ipairs(solids) do
        if self.collider:intersects(solid) then
            if self.vy > 0 then
                -- chão.
                self.collider.y = solid.y - solid.h/2 - self.collider.h/2
                self.on_ground = true
            elseif self.vy < 0 then
                -- teto.
                self.collider.y = solid.y + solid.h/2 + self.collider.h/2
            end
            self.y = self.collider.y - self.collider.oy
            self.vy = 0
            break
        end
    end
end

-- aplica a gravidade no corpo.
-- gravity = gravidade.
-- fall_speed = velocidade máxima de queda.
function PhysicsBody:apply_gravity(dt, gravity, fall_speed)
    dt = math.min(dt, 0.05)
    self.vy = math.min(self.vy + gravity * dt, fall_speed)
end

-- desenha o centro do corpo que é usado de referência para outros objetos.
function PhysicsBody:draw_center()
    local cx,cy = self:get_center()
    love.graphics.setColor(1,0,0)
    love.graphics.circle("fill",cx,cy,2)
    love.graphics.setColor(1,1,1)
end

function PhysicsBody:draw()
    love.graphics.rectangle("line",self.x,self.y,self.w,self.h)
end
return PhysicsBody