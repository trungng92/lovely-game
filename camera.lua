Camera = {}
Camera.__index = Camera

function Camera.new()
	local self = setmetatable({}, Camera)
	self.x = 0
	self.y = 0
	self.scale = 1
	self.angle = 0
	return self
end

function Camera:getCenter()
	return self.x + love.graphics.getWidth() / 2, self.y + love.graphics.getHeight() / 2
end

function Camera:shift(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

function Camera:setPos(x, y)
	self.x = x
	self.y = y
end

function Camera:zoom(scale)
	self.scale = self.scale + scale
end

function Camera:setZoom(scale)
	self.scale = scale
end

function Camera:rotate(angle)
	self.angle = self.angle + angle
end

function Camera:setRotate(angle)
	self.angle = angle
end

function Camera:drawStart()
	love.graphics.push()
	love.graphics.translate(self:getCenter())
	love.graphics.scale(self.scale, self.scale)
	love.graphics.rotate(self.angle)
end

function Camera:drawEnd()
	love.graphics.pop()
end