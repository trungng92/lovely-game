require 'misc'

Collideable = {}
Collideable.__index = Collideable

function Collideable.new(conv)
	local self = setmetatable({}, Collideable)
	self.conv = conv
	return self
end

function Collideable:isColliding(collideable)
	local x, y, w, h = collideable:getRect():get()
	return self:isCollidingRect(x, y, w, h)
end

function Collideable:isCollidingRect(x, y, w, h)
	local mex, mey, mew, meh = self.conv:say('get_rect')
	return	mex < x + w and
         	mex + mew > x and
         	mey < y + h and
         	mey + meh > y
end

function Collideable:debugDraw()
	local r, g, b, a = love.graphics.getColor()
	local newR = 255
	love.graphics.setColor(newR, 0, 0)
	local x, y, w, h = self.conv:say('get_rect')
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(r, g, b)
end