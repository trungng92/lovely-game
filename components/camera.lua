require 'components/collideable'
require 'components/rect'

Camera = {}
Camera.__index = Camera

function Camera.new(conv)
	local self = setmetatable({}, Camera)
	self.conv = conv
	
	self:setPos(0, 0)
	self:setZoom(1)

	return self
end

-- mousePosition gets the position of the mouse relative to the camera
-- i.e. the real world position
function Camera:getMousePosition()
	return (love.mouse.getX() - love.graphics.getWidth() / 2) / self.scale + self.x, (love.mouse.getY() - love.graphics.getHeight() / 2) / self.scale + self.y
end

-- camPosition gets the position of the center of the camera
function Camera:getCenter()
	return self.x + love.graphics.getWidth() / (2 * self.scale), self.y + love.graphics.getHeight() / (2 * self.scale)
end

function Camera:shift(x, y)
	self:setPos(self.x + x, self.y + y)
end

function Camera:setPos(x, y)
	self.x = x
	self.y = y
	self.conv:say('set_rect_xy', self.x, self.y)
end

function Camera:zoom(scale)
	self:setZoom(self.scale + scale)
end

function Camera:setZoom(scale)
	self.scale = scale
	local w = love.graphics.getWidth() * self.scale
	local h = love.graphics.getHeight() * self.scale
	self.conv:say('set_rect_wh', w, h)
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
	love.graphics.pop()
end

function Camera:debugDraw()
	-- not sure if there is anything I want for debugging
	-- right now we just put a red square at the world origin
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(255, 0, 0)
	local squareSize = 20
	love.graphics.rectangle("fill", -squareSize / 2, -squareSize / 2, squareSize, squareSize)
	love.graphics.setColor(r, g, b, a)
end