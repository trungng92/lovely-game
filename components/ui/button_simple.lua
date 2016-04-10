require 'misc'

ButtonSimple = {}
ButtonSimple.__index = ButtonSimple

function ButtonSimple.new(conv, cam, drawFn)
	local self = setmetatable({}, ButtonSimple)
	self.conv = conv
	self.pressed = false
	self.over = false
	-- what cam to use for determining collisions with the mouse
	self.cam = cam
	-- how to draw the button
	self.drawFn = drawFn
	return self
end

function ButtonSimple:cleanup()
	conversation:stopListening(self.convGroup)
end

function ButtonSimple:draw()
	self.drawFn()
end

function ButtonSimple:debugDraw()
	local r, g, b, a = love.graphics.getColor()
	local newR = 255
	local newG = 255 * boolToNum(self.conv:say('is_pressed_over'))
	love.graphics.setColor(newR, newG, 0)
	local x, y, w, h = self.conv:say('get_rect')
	love.graphics.rectangle("fill", x, y, w, h)
	love.graphics.setColor(r, g, b)
end