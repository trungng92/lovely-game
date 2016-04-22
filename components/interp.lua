Interp = {}
Interp.__index = Interp

-- Interp is used for doing interpolation where the value has to bounce back and forth
-- If you just want to do normal tweening/interpolation, just use the flux library directly
function Interp.new(conv)
	local self = setmetatable({}, Interp)
	self.conv = conv
	self.tween = nil

	return self
end

function Interp:setInterp(obj, time, minValues, maxValues)
	-- for now just always start at the max values
	local values = maxValues
	-- make a function so that in the tween we create we can call this function
	-- in the oncomplete callback
	local function func()
		-- I'm not sure if there is a performance hit creating a new tween object every time
		self.tween = flux.to(obj, time, values):oncomplete(func)
		if values == minValues then
			values = maxValues
		else
			values = minValues
		end
	end
	func()
end

function Interp:stopInterp()
	assert(self.tween ~= nil, 'Tried to stop interp, but tween was nil')
	self.tween:stop()
	self.tween = nil
end	
