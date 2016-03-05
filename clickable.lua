require('misc')

Clickable = {}
Clickable.__index = Clickable

function Clickable.new(cam, rect, action)
	local self = setmetatable({}, Clickable)
	self.pressed = false
	self.over = false
	-- what cam to use for rendering the position
	self.cam = cam
	-- bounding box to check for collisions
	-- i made this an object so it can be a reference
	self.rect = rect -- {x = 0, y = 0, w = 0, h = 0}
	-- action to be performed when click happens
	self.action = action
	self.debugDrawEnabled = true
	return self
end

function Clickable:setRect(rect)
	self.rect = rect
end

function Clickable:getRect()
	assert(self.rect ~= nil , 'tried to get rect, but it was nil')
	return self.rect
end

function Clickable:setCam(cam)
	self.cam = cam
end

function Clickable:getCam()
	assert(self.cam ~= nil , 'tried to get cam, but it was nil')
	return self.cam
end

-- getRectUnpacked is useful for when we want to return a tuple
function Clickable:getRectUnpacked()
	local rect = self.rect
	return rect.x, rect.y, rect.w, rect.h
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
	local x, y, w, h = self:getRectUnpacked()
	return checkCollision(x, y, w, h, mouseX, mouseY, 1, 1)
end

function Clickable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		local newR = 255
		local newG = 255 * boolToNum(self.pressed and self.over)
		love.graphics.setColor(newR, newG, 0)
		local squareSize = 20
		local rect = self:getRect()
		love.graphics.rectangle("fill",
			rect.x,
			rect.y,
			rect.w,
			rect.h)
		love.graphics.setColor(r, g, b, a)
	end
end