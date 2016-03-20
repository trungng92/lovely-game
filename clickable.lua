require('misc')

Clickable = {}
Clickable.__index = Clickable

function Clickable.new(cam, collideable, action, debugDraw)
	local self = setmetatable({}, Clickable)
	self.pressed = false
	self.over = false
	-- what cam to use for determining collisions with the mouse
	self.cam = cam
	self.collideable = collideable
	-- action to be performed when click happens
	self.action = action
	self.debugDrawEnabled = not not debugDraw
	return self
end

function Clickable:setCollideable(collideable)
	self.collideable = collideable
end

function Clickable:getCollideable()
	assert(self.collideable ~= nil, 'tried to get collideable, but it was nil')
	return self.collideable
end

function Clickable:setCam(cam)
	self.cam = cam
end

function Clickable:getCam()
	assert(self.cam ~= nil , 'tried to get cam, but it was nil')
	return self.cam
end

function Clickable:setAction(action)
	self.action = action
end

function Clickable:checkPress(mouseButton)
	-- only handle primary mouse button for clicks for now
	if mouseButton == 1 and self:isMouseColliding() then
		self.pressed = true
		self.over = true
	end
end

function Clickable:checkMove(mouseButton)
	self.over = self:isMouseColliding()
end

function Clickable:checkRelease(mouseButton)
	if mouseButton == 1 then
		if self.over then
			self:action()
		end
		self.pressed = false
		self.over = false
	end
end

function Clickable:isMouseColliding()
	local mouseX, mouseY = self:getCam():mousePosition()
	return self.collideable:isCollidingRect(mouseX, mouseY, 1, 1)
end

function Clickable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		local newG = 255 * boolToNum(self.pressed and self.over)
		love.graphics.setColor(newR, newG, 0)
		local rect = self:getCollideable():getRect()
		love.graphics.rectangle("fill", rect.x,	rect.y,	rect.w,	rect.h)
		love.graphics.setColor(r, g, b, a)
	end
end