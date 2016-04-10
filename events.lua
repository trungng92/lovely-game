local events = {
	'shift_cam',
	'zoom_cam',
	'cam_transform',
	'mouse_press',
	'mouse_move',
	'mouse_release'
	}

-- Action Requested are events that specify that you want something to happen
-- Action Performed are events that specify that an action has happened
eventsAR = {}
eventsAP = {}

for i, v in ipairs(events) do
	eventsAR[v] = 'action requested: ' .. v
	eventsAP[v] = 'action performed: ' .. v
end