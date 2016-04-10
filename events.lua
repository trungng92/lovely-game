local events = {
	'shift_cam',
	'zoom_cam',
	'cam_transform',
	'mouse_press',
	'mouse_move',
	'mouse_release'
	}

eventsAR = {}
eventsAP = {}

for i, v in ipairs(events) do
	eventsAR[v] = 'action requested: ' .. v
	eventsAP[v] = 'action performed: ' .. v
end