Rect = {}
Rect.__index = Rect

function Rect.new(x, y, w, h)
	local self = setmetatable({}, Rect)
	self.x = x or 0
	self.y = y or 0
	self.w = w or 0
	self.h = h or 0
	return self
end

function Rect:get()
	return self.x, self.y, self.w, self.h
end

function Rect:getObject()
	-- note that this returns a temporary object
	return {self.x, self.y, self.w, self.h}
end

function Rect:left()
	return self.x
end

function Rect:right()
	return self.x + self.w
end

function Rect:top()
	return self.y
end

function Rect:bottom()
	return self.y + self.h
end

function Rect:center()
	return self.x + self.w / 2, self.y + self.h / 2
end

function Rect:set(x, y, w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Rect:setX(x)
	self.x = x
end

function Rect:setY(y)
	self.y = y
end

function Rect:setW(w)
	self.w = w
end

function Rect:setH(h)
	self.h = h
end

function Rect:setXY(x, y)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end

function Rect:setWH(w, h)
	self.x = x
	self.y = y
	self.w = w
	self.h = h
end