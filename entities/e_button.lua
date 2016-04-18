require 'events'
require 'entities/base_entity'
require 'components/rect'
require 'components/collideable'
require 'components/clickable'
require 'components/ui/button_simple'
require 'components/ui/button'

EButton = {}
EButton.__index = EButton
setmetatable(EButton, {__index = BaseEntity})

function EButton.new(cam, rect, actionFn, drawFn, drawUpFn, drawDownFn, drawHoverOffFn, drawHoverFn)
	local self = setmetatable(BaseEntity.new(), EButton)

	-- no matter what create a new copy of the rect
	-- this also lets us pass in regular tables as long as they have x, y, w, h
	local x, y, w, h = rect.x or 0, rect.y or 0, rect.w or 0, rect.h or 0
	self.rect = Rect.new(x, y, w, h)
	self.convGroup:listen('get_rect', function()
		return self.rect:get()
	end)

	self.collideable = Collideable.new(self.conv, self.rect)
	self.convGroup:listen('is_colliding_rect', function(x, y, w, h)
		return self.collideable:isCollidingRect(x, y, w, h)
	end)

	self.button = Button.new(self.conv, actionFn, drawFn, drawUpFn, drawDownFn, drawHoverOffFn, drawHoverFn)
	local function updateFn()
		self.button:updateState()
	end

	-- pass in updateFn for pressFn, relaseFn, hoverFn, and hoverOffFn
	-- because this updates the state no matter what
	self.clickable = Clickable.new(self.conv, cam, actionFn, updateFn, updateFn, updateFn, updateFn)
	self.convGroup:listen('is_pressed', function()
		return self.clickable:isPressed()
	end)
	self.convGroup:listen('is_over', function()
		return self.clickable:isOver()
	end)

	-- These talk to the outside world, so they need to be made from the global conversation
	self.convGroupGlobal = conversation:newGroup()
	self.convGroupGlobal:listen(eventsAP['cam_transform'], function(cam)
		if cam == self.cam then
			self.clickable:checkMove()
		end
	end)
	self.convGroupGlobal:listen(eventsAP['mouse_press'], function(x, y, button, istouch)
		self.clickable:checkPress(button)
	end)
	self.convGroupGlobal:listen(eventsAP['mouse_move'], function(x, y, dx, dy)
		self.clickable:checkMove()
	end)
	self.convGroupGlobal:listen(eventsAP['mouse_release'], function(x, y, button, istouch)
		self.clickable:checkRelease(button)
	end)

	return self
end

function EButton:cleanup()
	BaseEntity.cleanup(self)
	conversation:stopListening(self.convGroupGlobal)
end

function EButton:draw()
	self.button:draw()
end

function EButton:debugDraw()
	self.button:debugDraw()
end