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

static func _reset_values_sp() -> void:
	smoothing_speed = SaveLoadHelper.save_data.get("game", 1).get("camera", 1).get("smoothing_speed", 1)
	print("Camera Smoothing Speed: ", smoothing_speed)

static func _reset_values_mp() -> void:
	#To add the other ones here!
	smoothing_speed = SaveLoadHelper.save_data.get("game", 1).get("camera", 1).get("smoothing_speed", 1)
	print("Camera Smoothing Speed: ", smoothing_speed)
