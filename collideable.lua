require 'components/rect'
require 'misc'

Collideable = {}
Collideable.__index = Collideable

function Collideable.new(rect, debugDraw)
	local self = setmetatable({}, Collideable)
	self.rect = rect
	self.debugDrawEnabled = not not debugDraw
	return self
end

function Collideable:setRect(rect)
	self.rect = rect
end

function Collideable:getRect()
	assert(self.rect ~= nil , 'tried to get rect, but it was nil')
	return self.rect
end

function Collideable:isColliding(collideable)
	local x, y, w, h = collideable:getRect():get()
	return self:isCollidingRect(x, y, w, h)
end

function Collideable:isCollidingRect(x, y, w, h)
	local me = self:getRect()
	return	me:left() < x + w and
         	me:right() > x and
         	me:top() < y + h and
         	me:bottom() > y
end

function Collideable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		love.graphics.setColor(newR, 0, 0)
		local x, y, w, h = self:getRect():get()
		love.graphics.rectangle("fill", x, y, w, h)
		love.graphics.setColor(r, g, b)
	end
end