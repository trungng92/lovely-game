
BaseEntity = {}
BaseEntity.__index = BaseEntity

function BaseEntity.new()
	return setmetatable({}, BaseEntity)
end

function BaseEntity:getComponent(componentName)
	return self[componentName]
end