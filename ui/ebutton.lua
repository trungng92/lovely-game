require 'misc'
require 'ui/button'
require 'clickable'
require 'collideable'
require 'lib/flux'

EButton = {}
EButton.__index = EButton

-- EButton is a prebuilt entity that represents a real button.
-- In addition to giving it a size and action, you can also choose how you want to draw it.
-- You can provide methods for drawing it in its up, down, mouse hover, and mouse hover off positions.
-- For the draw buttons, drawFn should tell the button how it should be drawn,
-- and all of the drawUpFn, drawDownFn, drawHover... functions
-- should say what state the button, so drawFn knows what it needs to do (e.g. if it needs to tween)
function EButton.new(cam, rect, actionFn, drawFn, drawUpFn, drawDownFn, drawHoverOffFn, drawHoverFn, debugDraw)
	local self = setmetatable({}, EButton)

	-- draw functions that tell us how to draw the button
	self.drawFn = drawFn or self.drawDefaultButton

	-- if we don't provide a draw function, then use the default drawing methods
	if drawFn == nil then
		-- note that you can provide a draw function alone
		-- but for drawUpFn and drawDownFn, you must provide neither or both
		-- This applies to the drawHover functions as well
		assert(drawUpFn == drawDownFn, 'expected both drawUpFn AND drawDownFn to be either provided or not provided')
		self.drawUpFn = drawUpFn or self.defaultDrawButtonUp
		self.drawDownFn = drawDownFn or self.defaultDrawButtonDown
		-- if we don't provide a mechanism to draw up and down, then draw using the default method
		if drawUpFn == nil and drawDownFn == nil then
			self.roundUp = 10
			self.roundDown = 30
			self.roundCurrent = self.roundUp
		end
		assert(drawHoverOffFn == drawHoverFn, 'expected both drawHoverOffFn AND drawHoverFn to be either provided or not provided')
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

	self.rect = rect

	self.collideable = Collideable.new(self.rect, false)

	local this = self
	local function updateFn()
		this:updateState()
	end

	-- pass in updateFn for pressFn, relaseFn, hoverFn, and hoverOffFn
	-- because this updates the state no matter what
	self.clickable = Clickable.new(cam, self.collideable, actionFn, updateFn, updateFn, updateFn, updateFn, false)

	function drawFn()
		this:drawFn()
	end
	self.button = Button.new(cam, self.clickable, drawFn, debugDraw)

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

function EButton:drawDefaultButton()
	local r, g, b, a = love.graphics.getColor()
	love.graphics.setColor(self.rCurrent, self.gCurrent, self.bCurrent, self.aCurrent)
	local x, y, w, h = self.rect:get()
	love.graphics.rectangle("fill", x, y, w, h, self.roundCurrent)
	love.graphics.setColor(r, g, b, a)
end

function EButton:defaultDrawButtonUp()
	flux.to(self, 0.2, {roundCurrent=self.roundUp})
end

function EButton:defaultDrawButtonDown()
	flux.to(self, 0.2, {roundCurrent=self.roundDown})
end

function EButton:defaultDrawButtonHoverOff()
	flux.to(self, 0.2, {rCurrent=self.colorHoverOff.r})
	flux.to(self, 0.2, {gCurrent=self.colorHoverOff.g})
	flux.to(self, 0.2, {bCurrent=self.colorHoverOff.b})
	flux.to(self, 0.2, {aCurrent=self.colorHoverOff.a})
end

function EButton:defaultDrawButtonHover()
	flux.to(self, 0.2, {rCurrent=self.colorHover.r})
	flux.to(self, 0.2, {gCurrent=self.colorHover.g})
	flux.to(self, 0.2, {bCurrent=self.colorHover.b})
	flux.to(self, 0.2, {aCurrent=self.colorHover.a})
end

-- Sets the new tweening for how the button should look like
function EButton:updateState()
	assert(self.clickable ~= nil, 'expected clickable to have a value')
	if self.clickable:isOver() then
		self:drawHoverFn()
		if self.clickable:isPressed() then
			self:drawDownFn()
		else
			self:drawUpFn()
		end
	else
		self:drawUpFn()
		self:drawHoverOffFn()
	end
end