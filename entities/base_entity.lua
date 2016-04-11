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

-- every component should have the ability to debug draw itself
-- however when we debug an entity, the entity should be in charge
-- of what "debug drawing" should look like
function BaseEntity:debugDraw()
end