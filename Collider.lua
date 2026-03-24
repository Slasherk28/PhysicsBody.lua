local Collider = {}

-- cria o colisor.
function Collider:new(x,y,w,h,ox,oy)
    local obj = {
        x = x or 0,
        y = y or 0,
        w = w or 0,
        h = h or 0,
        ox = ox or 0,
        oy = oy or 0
    }
    setmetatable(obj, {__index = Collider})
    return obj
end

-- atualiza a posição do colisor.
function Collider:update(x,y)
    self.x = x + self.ox
    self.y = y + self.oy
end

-- desenha o colisor de cor verde.
function Collider:draw()
    love.graphics.setColor(0,1,0)
    love.graphics.rectangle("line",
    self.x - self.w / 2,
    self.y - self.h / 2,
    self.w, self.h)
    love.graphics.setColor(1,1,1)
end

-- retorna a colisão. other é o objeto com que irá colidir.
function Collider:intersects(other)
    return
        self.x - self.w/2 < other.x + other.w/2 and
        self.x + self.w/2 > other.x - other.w/2 and
        self.y - self.h/2 < other.y + other.h/2 and
        self.y + self.h/2 > other.y - other.h/2
end
return Collider