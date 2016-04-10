require 'entities/base_entity'
require 'components/rect'
require 'components/collideable'
require 'components/camera'

ECamera = BaseEntity.new()
ECamera.__index = ECamera

function ECamera.new(debugDraw)
	local self = setmetatable({}, ECamera)
	local this = self

	-- useful if we want to check if anything is colliding with the camera (aka on screen)
	self.rect = Rect.new(0, 0, 0, 0)
	self.convGroup:listen('set_rect_xy', function(x, y)
		this.rect:setXY(x, y)
	end)
	self.convGroup:listen('set_rect_wh', function(w, h)
		this.rect:setWH(w, h)
	end)

	self.collideable = Collideable.new(self.conv)
	self.camera = Camera.new(self.conv)

	return self
end

function ECamera:debugDraw()
	self.camera:debugDraw()
end