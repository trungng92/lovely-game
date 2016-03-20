require('misc')

Collideable = {}
Collideable.__index = Collideable

function Collideable.new(rect, debugDraw)
	local self = setmetatable({}, Collideable)
	-- bounding box to check for collisions
	-- i made this an object so it can be a reference
	self.rect = rect -- {x = 0, y = 0, w = 0, h = 0}
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

-- getRectUnpacked is useful for when we want to return a tuple
function Collideable:getRectUnpacked()
	local rect = self:getRect()
	return rect.x, rect.y, rect.w, rect.h
end

function Collideable:isColliding(collideable)
	local rect = collideable:getRect()
	return self:isCollidingRect(rect.x, rect.y, rect.w, rect.h)
end

function Collideable:isCollidingRect(x, y, w, h)
	local me = self:getRect()
	return	me.x < x + w and
         	x    < me.x + me.w and
         	me.y < y + h and
         	y    < me.y + me.h
end

function Collideable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		love.graphics.setColor(newR, 0, 0)
		local rect = self:getRect()
		love.graphics.rectangle("fill",	rect.x,	rect.y,	rect.w,	rect.h)
		love.graphics.setColor(r, g, b, a)
	end
end