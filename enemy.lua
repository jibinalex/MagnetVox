-- actually based as hell
Enemy = Object:extend()

-- enemy constructor, takes xy coords and width/height
function Enemy:new(x, y, w, h, v, t)
  self.x, self.y = x, y
  self.initialy = y
  self.width, self.height = w, h
  self.speed = v
  self.timestamp = t
  self.point = 1
end

function Enemy:update(dt)
--   self.y = self.y + self.speed * dt
end

function Enemy:begone()
  self.initialy = self.initialy + 10000
 end

function Enemy:draw(t)
  self.y = self.initialy + self.speed * (t - self.timestamp)
  love.graphics.rectangle("fill", self.x, self.y, self.width, self.height)
end

function Enemy:getEnemyProperties()
  return self.x, self.y, self.height, self.width
end
