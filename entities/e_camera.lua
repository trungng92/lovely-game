require 'entities/base_entity'
require 'components/rect'
require 'components/collideable'
require 'components/camera'

ECamera = BaseEntity.new()
ECamera.__index = ECamera

function ECamera.new(debugDraw)
	local self = setmetatable({}, ECamera)

	-- useful if we want to check if anything is colliding with the camera (aka on screen)
	self.rect = Rect.new(0, 0, 0, 0)

	self.collideable = Collideable.new(self.rect)
	self.camera = Camera.new(self.rect)

	self.debugDrawEnabled = not not debugDraw
	return self
end
