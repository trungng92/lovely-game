require 'camera'
require 'ui/ebutton'
flux = require 'lib/flux'

-- show console output
io.stdout:setvbuf("no")

function love.load()
	cam = Camera.new()

	local rect = {x = -100, y = -100, w = 200, h = 200}
	local action = function()
		print('hello')
	end

	ebutton = EButton.new(cam, rect, action)
end

function love.draw()
	love.graphics.print('click to make squares', 10, 10)
	love.graphics.print('move the camera with the arrow keys', 10, 30)
	love.graphics.print('zoom in and out with - and =', 10, 50)
	cam:drawStart()
	ebutton:draw()
	cam:drawEnd()
end

function love.update(dt)
	flux.update(dt)

	camShift = 10
	if love.keyboard.isDown('left') then
	    cam:shift(-camShift, 0)
		ebutton:getButton():getClickable():checkMove(1)
	elseif love.keyboard.isDown('right') then
	    cam:shift(camShift, 0)
		ebutton:getButton():getClickable():checkMove(1)
	end
	if love.keyboard.isDown('up') then
	    cam:shift(0, -camShift)
		ebutton:getButton():getClickable():checkMove(1)
	elseif love.keyboard.isDown('down') then
		cam:shift(0, camShift)
		ebutton:getButton():getClickable():checkMove(1)
	end
	if love.keyboard.isDown('-') then
		cam:zoom(-.01)
		ebutton:getButton():getClickable():checkMove(1)
	elseif love.keyboard.isDown('=') then
		cam:zoom(.01)
		ebutton:getButton():getClickable():checkMove(1)
	end
end

function love.mousepressed(x, y, button, istouch)
	ebutton:getButton():getClickable():checkPress(1)
end

function love.mousemoved(x, y, button, istouch)
	ebutton:getButton():getClickable():checkMove(1)
end

function love.mousereleased(x, y, button, istouch)
	ebutton:getButton():getClickable():checkRelease(1)
end