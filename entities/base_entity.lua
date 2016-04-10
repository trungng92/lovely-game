require 'lib/include'

BaseEntity = {}
BaseEntity.__index = BaseEntity

function BaseEntity.new()
	local self = setmetatable({}, BaseEntity)
	-- set a talkback conversation so that an entity (and its components can talk to one another through it)
	self.conv = talkback.new()
	self.convGroup = self.conv:newGroup()
	return self
end

function BaseEntity:getComponent(componentName)
	return self[componentName]
end

function BaseEntity:cleanup()
	self.conv:stopListening(self.convGroup)
end

function BaseEntity:debugDraw()
end