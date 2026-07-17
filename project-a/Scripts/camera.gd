class_name CameraHelper

# Camera settings
static var min_zoom : Vector2
static var max_zoom : Vector2
static var margin : Vector2 # Space around the players in pixels
static var smoothing_speed : float

static func _set_initial_camera_values_sp() -> void:
	smoothing_speed = 5.0

static func _set_initial_camera_values_mp() -> void:
	min_zoom = Vector2(1.0, 1.0)
	max_zoom = Vector2(0.5, 0.5)
	margin = Vector2(100, 100) # Space around the players in pixels
	smoothing_speed = 5.0
