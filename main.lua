require 'events'
require 'entities/e_camera'
require 'ui/ebutton'
require 'components/rect'
flux = require 'lib/flux'
talkback = require 'lib/talkback'

-- show console output
io.stdout:setvbuf("no")

function love.load()
	conversation = talkback.new()
	cam = ECamera.new()
	local ccam = cam:getComponent('camera')
	-- I should probably save the return values
	-- if I want to clean up the conversations later
	conversation:listen(eventsAR['shift_cam'], function(x, y)
		cam:getComponent('camera'):shift(x, y)
	end)

	conversation:listen(eventsAR['zoom_cam'], function(z)
		cam:getComponent('camera'):zoom(z)
	end)

	local rect = Rect.new(-100, -100, 200, 200)
	local action = function()
		print('hello')
	end

	ebutton = EButton.new(cam:getComponent('camera'), rect, action)
end

function love.draw()
	love.graphics.print('click to make squares', 10, 10)
	love.graphics.print('move the camera with the arrow keys', 10, 30)
	love.graphics.print('zoom in and out with - and =', 10, 50)
	cam:getComponent('camera'):drawStart()
	ebutton:draw()
	cam:getComponent('camera'):drawEnd()
end

function love.update(dt)
	flux.update(dt)

	camShift = 10
	if love.keyboard.isDown('left') then
		conversation:say(eventsAR['shift_cam'], -camShift, 0)
	elseif love.keyboard.isDown('right') then
		conversation:say(eventsAR['shift_cam'], camShift, 0)
	end
	if love.keyboard.isDown('up') then
		conversation:say(eventsAR['shift_cam'], 0, -camShift)
	elseif love.keyboard.isDown('down') then
		conversation:say(eventsAR['shift_cam'], 0, camShift)
	end
	if love.keyboard.isDown('-') then
		conversation:say(eventsAR['zoom_cam'], -0.01)
	elseif love.keyboard.isDown('=') then
		conversation:say(eventsAR['zoom_cam'], 0.01)
	end

	if love.keyboard.isDown('left', 'right', 'up', 'down', '-', '=') then
		conversation:say('cam transformed', cam:getComponent('camera'))
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