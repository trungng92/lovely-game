require('misc')

Clickable = {}
Clickable.__index = Clickable

function Clickable.new()
	local self = setmetatable({}, Clickable)
	-- action to be performed when
	self.action = nil
	-- bounding box to check for collisions
	-- i made this an object so it can be a reference
	self.rect = nil -- {x = 0, y = 0, w = 0, h = 0}
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

function Clickable:checkClick(camera, mouseButton, mouseX, mouseY)
	local x, y, w, h = self:getRectUnpacked()
	local camX, camY = camera:camPosition()
	x, y = x + camX - w / 2, y + camY - w / 2

	if self.action ~= nil and
			love.mouse.isDown(mouseButton) and
			checkCollision(x, y, w, h, mouseX, mouseY, 1, 1) then

		self:action();
	end
end

function Clickable:debugDraw()
	if self.debugDrawEnabled then
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255, 0, 0)
		local squareSize = 20
		love.graphics.rectangle("fill",
			self.rect.x - self.rect.w / 2,
			self.rect.y - self.rect.h / 2,
			self.rect.w,
			self.rect.h)
		love.graphics.setColor(r, g, b, a)
	end
end