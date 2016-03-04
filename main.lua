require 'camera'
require 'clickable'

-- show console output
io.stdout:setvbuf("no")

function love.load()
	cam = Camera.new()
	rects = {}
	clickable = Clickable.new()
	clickable:setRect({x = 0, y = 0, w = 200, h = 200})
	clickable:setAction(function()
		print('hello')
	end)
end

function love.draw()
	love.graphics.print('click to make squares', 10, 10)
	love.graphics.print('move the camera with the arrow keys', 10, 30)
	love.graphics.print('zoom in and out with - and =', 10, 50)
	love.graphics.print('rotate camera with o and p', 10, 70)
	cam:drawStart()
	clickable:debugDraw()

	for i,v in ipairs(rects) do
		love.graphics.rectangle("fill", v.x - v.w / 2, v.y - v.h / 2, v.w, v.h)
	end

	cam:drawEnd()
end

function love.update(dt)
	local mouseX, mouseY = cam:mousePosition()
	clickable:checkClick(cam, 1, mouseX, mouseY)
	camShift = 10
	if love.keyboard.isDown('left') then
	    cam:shift(-camShift, 0)
	elseif love.keyboard.isDown('right') then
	    cam:shift(camShift, 0)
	end
	if love.keyboard.isDown('up') then
	    cam:shift(0, -camShift)
	elseif love.keyboard.isDown('down') then
		cam:shift(0, camShift)
	end
	if love.keyboard.isDown('-') then
		cam:zoom(-.01)
	elseif love.keyboard.isDown('=') then
		cam:zoom(.01)
	end
end

function love.mousepressed(x, y, button, istouch)
	local camx, camy = cam:getCenter()
	local xReal = (x - love.graphics.getWidth() / 2) / cam.scale + cam.x
	local yReal = (y - love.graphics.getHeight() / 2) / cam.scale + cam.y
	local newRect = {
		x = xReal,
		y = yReal,
		w = 100 * love.math.random(),
		h = 100 * love.math.random(),
	}
	table.insert(rects, newRect)
end