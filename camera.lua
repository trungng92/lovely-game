require 'components/collideable'
require 'components/rect'

Camera = {}
Camera.__index = Camera

function Camera.new(debugDraw)
	local self = setmetatable({}, Camera)
	self.x = 0
	self.y = 0
	self.scale = 1

	-- useful if we want to check if anything is colliding with the camera (aka on screen)
	self.rect = Rect.new(
		self.x,
		self.y,
		love.graphics.getWidth() * self.scale,
		love.graphics.getHeight() * self.scale)
	self.collideable = Collideable.new(self.rect)

	self.debugDrawEnabled = not not debugDraw
	return self
end

function Camera:getCollideable()
	assert(self.collideable ~= nil, 'tried to get collideable, but it was nil')
	return self.collideable
end

function Camera:getRect()
	assert(self.rect ~= nil, 'tried to get rect, but it was nil')
	return self.rect
end

function Camera:getCenter()
	return self.x + love.graphics.getWidth() / 2, self.y + love.graphics.getHeight() / 2
end

function Camera:shift(x, y)
	self.x = self.x + x
	self.y = self.y + y
	self:getRect():setXY(self.x, self.y)
end

function Camera:setPos(x, y)
	self.x = x
	self.y = y
	self:getRect():setXY(self.x, self.y)
end

function Camera:zoom(scale)
	self.scale = self.scale + scale
	self:getRect():setWH(love.graphics.getWidth() * self.scale, love.graphics.getHeight() * self.scale)
end

function Camera:setZoom(scale)
	self.scale = scale
	self:getRect():setWH(love.graphics.getWidth() * self.scale, love.graphics.getHeight() * self.scale)
end

function Camera:drawStart()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	love.graphics.scale(self.scale, self.scale)
	-- shift in the opposite direction
	-- because if the camera moves right,
	-- then that's equivalent to shifting everything to the left
	love.graphics.translate(-self.x, -self.y)
end

function Camera:drawEnd()
	-- draw debug at the end so that it appears over other draws
	self:debugDraw()
	love.graphics.pop()
end

function Camera:debugDraw()
	if self.debugDrawEnabled then
		-- not sure if there is anything I want for debugging
		-- right now we just put a red square at the world origin
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255, 0, 0)
		local squareSize = 20
		love.graphics.rectangle("fill", -squareSize / 2, -squareSize / 2, squareSize, squareSize)
		love.graphics.setColor(r, g, b, a)
	end
end

-- mousePosition gets the position of the mouse relative to the camera
-- i.e. the real world position
function Camera:mousePosition()
	return (love.mouse.getX() - love.graphics.getWidth() / 2) / self.scale + self.x, (love.mouse.getY() - love.graphics.getHeight() / 2) / self.scale + self.y
end

-- camPosition gets the position of the center of the camera
function Camera:camPosition()
	return self.x + love.graphics.getWidth() / (2 * self.scale), self.y + love.graphics.getHeight() / (2 * self.scale)
end