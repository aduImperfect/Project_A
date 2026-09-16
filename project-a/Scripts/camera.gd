extends Node
# Registered as Autoload: CameraHelper

signal value_changed(property: String, new_value)

# Camera settings
static var min_zoom : Vector2
static var max_zoom : Vector2
static var margin : Vector2
static var smoothing_speed : float
static var position_cam : Vector2

# Camera window
static var left_inset : float
static var right_inset : float
static var top_inset : float
static var bottom_inset : float

# Camera behaviour
static var window_push_speed : float
static var platform_snap_speed : float
static var clamp_camera_to_world_bounds : bool

func set_value(property: String, new_value) -> void:
	set(property, new_value)
	value_changed.emit(property, new_value)

func _set_initial_camera_values_sp() -> void:
	#position = Vector2.ZERO
	smoothing_speed = 5.0
	left_inset = 0.0
	right_inset = 0.0
	top_inset = 0.0
	bottom_inset = 0.0
	value_changed.emit("smoothing_speed", smoothing_speed)

func _set_initial_camera_values_mp() -> void:
	#position = Vector2.ZERO
	min_zoom = Vector2(1.0, 1.0)
	max_zoom = Vector2(0.5, 0.5)
	margin = Vector2(100, 100) # Space around the players in pixels
	smoothing_speed = 5.0
	value_changed.emit("smoothing_speed", smoothing_speed)

func _reset_values_sp() -> void:
	#position = Vector2.ZERO
	smoothing_speed = SaveLoadHelper.save_data.get("game", 1).get("camera", 1).get("smoothing_speed", 1)
	print("Camera Smoothing Speed: ", smoothing_speed)
	value_changed.emit("smoothing_speed", smoothing_speed)

func _reset_values_mp() -> void:
	#To add the other ones here!
	#position = Vector2.ZERO
	smoothing_speed = SaveLoadHelper.save_data.get("game", 1).get("camera", 1).get("smoothing_speed", 1)
	print("Camera Smoothing Speed: ", smoothing_speed)
	value_changed.emit("smoothing_speed", smoothing_speed)
