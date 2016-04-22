require 'entities/base_entity'
require 'components/rect'
require 'components/collideable'
require 'components/camera'

ECamera = {}
ECamera.__index = ECamera
setmetatable(ECamera, {__index = BaseEntity})

function ECamera.new(debugDraw)
	local self = setmetatable(BaseEntity.new(), ECamera)

	-- useful if we want to check if anything is colliding with the camera (aka on screen)
	self.rect = Rect.new(0, 0, 0, 0)
	self.convGroup:listen('set_rect_xy', function(x, y)
		self.rect:setXY(x, y)
	end)
	self.convGroup:listen('set_rect_wh', function(w, h)
		self.rect:setWH(w, h)
	end)

	self.collideable = Collideable.new(self.conv)
	self.camera = Camera.new(self.conv)

	return self
end

function ECamera:debugDraw()
	self.camera:debugDraw()
end