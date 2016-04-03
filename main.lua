require 'camera'
require 'ui/ebutton'
require 'components/rect'
flux = require 'lib/flux'
talkback = require 'lib/talkback'

-- show console output
io.stdout:setvbuf("no")

function love.load()
	conversation = talkback.new()
	cam = Camera.new()

	local rect = Rect.new(-100, -100, 200, 200)
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

	if love.keyboard.isDown('left', 'right', 'up', 'down', '-', '=') then
		conversation:say('cam transformed', cam)
	end
end

function love.mousepressed(x, y, button, istouch)
	conversation:say('mouse pressed', x, y, button, istouch)
end

function love.mousemoved(x, y, dx, dy)
	conversation:say('mouse moved', x, y, dx, dy)
end

function love.mousereleased(x, y, button, istouch)
	conversation:say('mouse released', x, y, button, istouch)
end