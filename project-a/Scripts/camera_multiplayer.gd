extends Camera2D

func _ready():
	CameraHelper._set_initial_camera_values_mp()

func _process(_delta : float):
	if PlayersHelper.playerNodes.is_empty():
		print("No players to play!")
		return

	# 1. Find the center point
	var center = Vector2.ZERO
	for player in PlayersHelper.playerNodes:
		center += player.get_child(0).global_position
	center /= PlayersHelper.playerNodes.size()
	
	# 2. Find the furthest distance
	var max_distance = 0.0
	for player in PlayersHelper.playerNodes:
		var distance = center.distance_to(player.get_child(0).global_position)
		if distance > max_distance:
			max_distance = distance
	
	# 3. Calculate Zoom
	var viewport_size = get_viewport_rect().size - CameraHelper.margin
	var zoom_x = max_distance * 2.0 / viewport_size.x
	var zoom_y = max_distance * 2.0 / viewport_size.y
	var target_zoom = Vector2(max(zoom_x, zoom_y), max(zoom_x, zoom_y))
	
	# Clamp zoom to prevent getting too close or too far
	target_zoom = target_zoom.clamp(CameraHelper.min_zoom, CameraHelper.max_zoom)
	
	# Smoothly move and zoom
	global_position = global_position.lerp(center, CameraHelper.smoothing_speed * _delta)
	zoom = zoom.lerp(target_zoom, CameraHelper.smoothing_speed * _delta)
