require 'camera'

-- show console output
io.stdout:setvbuf("no")

function love.load()
	cam = Camera.new()
	rects = {}
end

function love.draw()
	love.graphics.print('click to make squares', 10, 10)
	love.graphics.print('move the camera with the arrow keys', 10, 30)
	love.graphics.print('zoom in and out with - and =', 10, 50)
	love.graphics.print('rotate camera with o and p', 10, 70)
	cam:drawStart()

	for i,v in ipairs(rects) do
		love.graphics.rectangle("fill", v.x - v.w / 2, v.y - v.h / 2, v.w, v.h)
	end

	cam:drawEnd()
end

function love.update(dt)
	if love.keyboard.isDown('left') then
	    cam:shift(-10, 0)
	elseif love.keyboard.isDown('right') then
	    cam:shift(10, 0)
	elseif love.keyboard.isDown('up') then
	    cam:shift(0, -10)
	elseif love.keyboard.isDown('down') then
		cam:shift(0, 10)
	elseif love.keyboard.isDown('-') then
		cam:zoom(-.01)
	elseif love.keyboard.isDown('=') then
		cam:zoom(.01)
	elseif love.keyboard.isDown('o') then
		cam:rotate(-math.pi / 60)
	elseif love.keyboard.isDown('p') then
		cam:rotate(math.pi / 60)
	end
end

function love.mousepressed(x, y, button, istouch)
	local camx, camy = cam:getCenter()
	local xReal = x - camx
	local yReal = y - camy
	local newRect = {x = xReal, y = yReal, w = 100 * love.math.random(), h = 100 * love.math.random()}
	table.insert(rects, newRect)
end