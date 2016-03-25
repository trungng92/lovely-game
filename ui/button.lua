require('misc')

Button = {}
Button.__index = Button

function Button.new(cam, clickable, drawUp, drawDown, debugDraw)
	local self = setmetatable({}, Button)
	self.pressed = false
	self.over = false
	-- what cam to use for determining collisions with the mouse
	self.cam = cam
	-- note that the action is maintained inside the clickable component
	-- this way if I add different components like dragging,
	-- then then each component can control how it wants to deal with it.
	self.clickable = clickable
	-- function that displays we want the button to look like in the up/down state
	self.drawUp = drawUp or drawDefaultButtonUp
	self.drawDown = drawDown or drawDefaultButtonDown

	self.debugDrawEnabled = not not debugDraw
	return self
end

function Button:setClickable(clickable)
	self.clickable = clickable
end

function Button:getClickable()
	assert(self.clickable ~= nil, 'tried to get clickable, but it was nil')
	return self.clickable
end

function Button:setCam(cam)
	self.cam = cam
end

function Button:getCam()
	assert(self.cam ~= nil , 'tried to get cam, but it was nil')
	return self.cam
end

function Button:draw()
	if self:getClickable():isPressed() and self:getClickable():isOver() then
		self:drawDown()
	else
		self:drawUp()
	end
end

function Button:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		local newG = 255 * boolToNum(self:getClickable():isPressed() and self:getClickable():isOver())
		love.graphics.setColor(newR, newG, 0)
		local rect = self:getCollideable():getRect()
		love.graphics.rectangle("fill", rect.x,	rect.y,	rect.w,	rect.h)
		love.graphics.setColor(r, g, b, a)
	end
end

function drawDefaultButtonUp(button)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(255, 0, 0)
	local rect = button:getClickable():getCollideable():getRect()
	love.graphics.rectangle("fill", rect.x,	rect.y,	rect.w,	rect.h, 20)
	love.graphics.setColor(r, g, b, a)
end

function drawDefaultButtonDown(button)
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(0, 255, 0)
	local rect = button:getClickable():getCollideable():getRect()
	love.graphics.rectangle("fill", rect.x,	rect.y,	rect.w,	rect.h, 20)
	love.graphics.setColor(r, g, b, a)
end
