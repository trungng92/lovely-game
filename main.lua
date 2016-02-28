function love.load()
	pos = {x = 0, y = 0}
	success = love.system.openURL('google.com')
	print(success)
end

function love.draw()
	love.graphics.print("Hello World", 400, 300)
	local size = {x = 100, y = 100}
	love.graphics.rectangle("fill", pos.x - size.x / 2, pos.y - size.y / 2, size.x, size.y)
end

function love.update(dt)
	down = love.mouse.isDown(1)
	if(down) then
		pos.x, pos.y = love.mouse.getPosition()
	end
end