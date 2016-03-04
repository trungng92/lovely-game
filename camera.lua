Camera = {}
Camera.__index = Camera

function Camera.new()
	local self = setmetatable({}, Camera)
	self.x = 0
	self.y = 0
	self.scale = 1
	self.debugDrawEnabled = true
	return self
end

function Camera:getCenter()
	return self.x + love.graphics.getWidth() / 2, self.y + love.graphics.getHeight() / 2
end

function Camera:shift(x, y)
	self.x = self.x + x
	self.y = self.y + y
end

function Camera:setPos(x, y)
	self.x = x
	self.y = y
end

function Camera:zoom(scale)
	self.scale = self.scale + scale
end

function Camera:setZoom(scale)
	self.scale = scale
end

function Camera:drawStart()
	love.graphics.push()
	love.graphics.translate(love.graphics.getWidth() / 2, love.graphics.getHeight() / 2)
	love.graphics.scale(self.scale, self.scale)
	-- shift in the opposite direction
	-- because if the camera moves right,
	-- then that's equivalent to shifting everything to the left
	love.graphics.translate(-self.x, -self.y)
end

function Camera:drawEnd()
	-- draw debug at the end so that it appears over other draws
	self:debugDraw()
	love.graphics.pop()
end

function Camera:debugDraw()
	if self.debugDrawEnabled then
		-- not sure if there is anything I want for debugging
		-- right now we just put a red square at the world origin
		local r, g, b, a = love.graphics.getColor()
		love.graphics.setColor(255, 0, 0)
		local squareSize = 20
		love.graphics.rectangle("fill", -squareSize / 2, -squareSize / 2, squareSize, squareSize)
		love.graphics.setColor(r, g, b, a)
	end
end