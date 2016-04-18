require 'misc'

Button = {}
Button.__index = Button

-- In addition to giving it a size and action, you can also choose how you want to draw it.
-- You can provide methods for drawing it in its up, down, mouse hover, and mouse hover off positions.
-- For the draw buttons, drawFn should tell the button how it should be drawn,
-- and all of the drawUpFn, drawDownFn, drawHover... functions
-- should say what state the button, so drawFn knows what it needs to do (e.g. if it needs to tween)
function Button.new(conv, actionFn, drawFn, drawUpFn, drawDownFn, drawHoverOffFn, drawHoverFn)
	local self = setmetatable({}, Button)
	self.conv = conv

	-- draw functions that tell us how to draw the button
	self.drawFn = drawFn or self.drawDefaultButton

	-- if we don't provide a draw function, then use the default drawing methods
	if drawFn == nil then
		-- note that you can provide a draw function alone
		-- but for drawUpFn and drawDownFn, you must provide neither or both
		-- This applies to the drawHover functions as well
		assert(toBool(drawUpFn) == toBool(drawDownFn), 'expected both drawUpFn AND drawDownFn to be either provided or not provided')
		self.drawUpFn = drawUpFn or self.defaultDrawButtonUp
		self.drawDownFn = drawDownFn or self.defaultDrawButtonDown
		-- if we don't provide a mechanism to draw up and down, then draw using the default method
		if drawUpFn == nil and drawDownFn == nil then
			self.roundUp = 10
			self.roundDown = 30
			self.roundCurrent = self.roundUp
		end
		assert(toBool(drawHoverOffFn) == toBool(drawHoverFn), 'expected both drawHoverOffFn AND drawHoverFn to be either provided or not provided')
		self.drawHoverOffFn = drawHoverOffFn or self.defaultDrawButtonHoverOff
		self.drawHoverFn = drawHoverFn or self.defaultDrawButtonHover
		-- if we don't provide a mechanism to draw, then draw using the default method
		if drawHoverOffFn == nil and drawHoverFn == nil then
			self.colorHover = {r=255, g=0, b=0, a=255}
			self.colorHoverOff = {r=150, g=0, b=0, a=255}
			-- flux doesn't tween objects, so get the individual values
			self.rCurrent = self.colorHoverOff.r
			self.gCurrent = self.colorHoverOff.g
			self.bCurrent = self.colorHoverOff.b
			self.aCurrent = self.colorHoverOff.a
		end
	end

	return self
end

function Button:draw()
	self:drawFn()
end

-- Sets the new tweening for how the button should look like
function Button:updateState()
	if self.conv:say('is_over') then
		self:drawHoverFn()
		if self.conv:say('is_pressed') then
			self:drawDownFn()
		else
			self:drawUpFn()
		end
	else
		self:drawUpFn()
		self:drawHoverOffFn()
	end
end

function Button:drawDefaultButton()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.rCurrent, self.gCurrent, self.bCurrent, self.aCurrent)
	local x, y, w, h = self.conv:say('get_rect')
	love.graphics.rectangle("fill", x, y, w, h, self.roundCurrent)
	love.graphics.setColor(r, g, b, a)
end

function Button:defaultDrawButtonUp()
	flux.to(self, 0.2, {roundCurrent=self.roundUp})
end

function Button:defaultDrawButtonDown()
	flux.to(self, 0.2, {roundCurrent=self.roundDown})
end

function Button:defaultDrawButtonHoverOff()
	flux.to(self, 0.2, {rCurrent=self.colorHoverOff.r})
	flux.to(self, 0.2, {gCurrent=self.colorHoverOff.g})
	flux.to(self, 0.2, {bCurrent=self.colorHoverOff.b})
	flux.to(self, 0.2, {aCurrent=self.colorHoverOff.a})
end

function Button:defaultDrawButtonHover()
	flux.to(self, 0.2, {rCurrent=self.colorHover.r})
	flux.to(self, 0.2, {gCurrent=self.colorHover.g})
	flux.to(self, 0.2, {bCurrent=self.colorHover.b})
	flux.to(self, 0.2, {aCurrent=self.colorHover.a})
end

function Button:debugDraw()
	-- TODO implement this (maybe with the default settings?)
end
