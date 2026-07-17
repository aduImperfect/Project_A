extends Camera2D

# Camera settings
@export var min_zoom = Vector2(1.0, 1.0)
@export var max_zoom = Vector2(0.5, 0.5)
@export var margin = Vector2(100, 100) # Space around the players in pixels
@export var smoothing_speed = 5.0

func _ready():
	pass

func _process(delta):
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
	var viewport_size = get_viewport_rect().size - margin
	var zoom_x = max_distance * 2.0 / viewport_size.x
	var zoom_y = max_distance * 2.0 / viewport_size.y
	var target_zoom = Vector2(max(zoom_x, zoom_y), max(zoom_x, zoom_y))
	
	# Clamp zoom to prevent getting too close or too far
	target_zoom = target_zoom.clamp(min_zoom, max_zoom)
	
	# Smoothly move and zoom
	global_position = global_position.lerp(center, smoothing_speed * delta)
	zoom = zoom.lerp(target_zoom, smoothing_speed * delta)
