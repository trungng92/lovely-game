require 'misc'

Button = {}
Button.__index = Button

function Button.new(cam, clickable, drawFn, debugDraw)
	local self = setmetatable({}, Button)
	self.pressed = false
	self.over = false
	-- what cam to use for determining collisions with the mouse
	self.cam = cam
	-- note that the action is maintained inside the clickable component
	-- this way if I add different components like dragging,
	-- then then each component can control how it wants to deal with it.
	self.clickable = clickable

	-- should these just be in clickable?
	local this = self
	self.listenCamTransformed = conversation:listen('cam transformed', function(cam)
		if cam == this.cam then
			this:getClickable():checkMove()
		end
	end)
	self.listenMousePressed = conversation:listen('mouse pressed', function(x, y, button, istouch)
		this:getClickable():checkPress(button)
	end)
	self.listenMouseMoved = conversation:listen('mouse moved', function(x, y, dx, dy)
		this:getClickable():checkMove()
	end)
	self.listenMouseReleased = conversation:listen('mouse released', function(x, y, button, istouch)
		this:getClickable():checkRelease(button)
	end)
	-- how to draw the button
	self.drawFn = drawFn

	self.debugDrawEnabled = not not debugDraw
	return self
end

function Button:cleanup()
	conversation:stopListening(self.listenCamTransformed)
	conversation:stopListening(self.listenMousePressed)
	conversation:stopListening(self.listenMouseMoved)
	conversation:stopListening(self.listenMouseReleased)
end

function Button:setClickable(clickable)
	self.clickable = clickable
end

function Button:getClickable()
	assert(self.clickable ~= nil, 'tried to get clickable, but it was nil')
	return self.clickable
end

function Button:draw()
	self.drawFn()
end

function Button:debugDraw()
	if self.debugDrawEnabled then
		local clickable = self:getClickable()
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		local newG = 255 * boolToNum(clickable:isPressed() and clickable:isOver())
		love.graphics.setColor(newR, newG, 0)
		local x, y, w, h = clickable:getCollideable():getRect():get()
		love.graphics.rectangle("fill", x, y, w, h)
		love.graphics.setColor(r, g, b)
	end
end