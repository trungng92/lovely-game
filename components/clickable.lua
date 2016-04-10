require 'misc'

Clickable = {}
Clickable.__index = Clickable

function Clickable.new(conv, cam, clickActionFn, pressFn, releaseFn, hoverFn, hoverOffFn, debugDraw)
	local self = setmetatable({}, Clickable)
	self.conv = conv
	self.pressed = false
	self.over = false
	-- what cam to use for determining collisions with the mouse
	self.cam = cam
	-- action to be performed when click happens
	self.clickActionFn = clickActionFn

	-- these four are optional
	self.pressFn = pressFn
	self.releaseFn = releaseFn
	self.hoverFn = hoverFn
	self.hoverOffFn = hoverOffFn

	self.debugDrawEnabled = not not debugDraw
	return self
end

function Clickable:isPressed()
	return self.pressed
end

function Clickable:isOver()
	return self.over
end


function Clickable:setCam(cam)
	self.cam = cam
end

function Clickable:getCam()
	assert(self.cam ~= nil , 'tried to get cam, but it was nil')
	return self.cam
end

function Clickable:checkPress(mouseButton)
	local leftMouseButton = 1
	mouseButton = mouseButton or leftMouseButton
	-- only handle primary mouse button for clicks for now
	if mouseButton == leftMouseButton and self:isMouseColliding() then
		self.pressed = true
		self.over = true
		if self.pressFn then
			self.pressFn()
		end
	end
end

function Clickable:checkMove()
	local beforeOver = self.over
	self.over = self:isMouseColliding()
	if self.over ~= beforeOver then
		if self.over and self.hoverFn then
			self.hoverFn()
		elseif not self.over and self.hoverOffFn then
			self.hoverOffFn()
		end
	end
end

function Clickable:checkRelease(mouseButton)
	local leftMouseButton = 1
	mouseButton = mouseButton or leftMouseButton
	if mouseButton == leftMouseButton then
		if self.over then
			self:clickActionFn()
		end
		self.pressed = false

		if self.releaseFn then
			self.releaseFn()
		end
	end
end

function Clickable:isMouseColliding()
	local mouseX, mouseY = self:getCam():getMousePosition()
	return self.conv:say('is_colliding_rect', mouseX, mouseY, 1, 1)
end

function Clickable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		local newG = 255 * boolToNum(self.pressed and self.over)
		love.graphics.setColor(newR, newG, 0)
		local x, y, w, h = self.conv:say('get_rect')
		love.graphics.rectangle("fill", x, y, w, h)
		love.graphics.setColor(r, g, b)
	end
end