require('misc')

EButton = {}
EButton.__index = EButton

function EButton.new(cam, rect, action, drawUp, drawDown, debugDraw)
	local self = setmetatable({}, EButton)

	-- function that displays we want the button to look like in the up/down state
	self.drawUp = drawUp or drawDefaultButtonUp
	self.drawDown = drawDown or drawDefaultButtonDown

	local collideable = Collideable.new(rect, false)
	local clickable = Clickable.new(cam, collideable, action, false)
	self.button = Button.new(cam, clickable, self.drawUp, self.drawDown, debugDraw)

	return self
end

function EButton:setButton(button)
	self.button = button
end

function EButton:getButton()
	assert(self.button ~= nil, 'tried to get button, but it was nil')
	return self.button
end

function EButton:draw()
	self.button:draw()
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
