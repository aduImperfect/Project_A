extends Node
# Registered as Autoload: CameraHelper

signal value_changed(property: String, new_value)

# Camera settings
var min_zoom : Vector2
var max_zoom : Vector2
var margin : Vector2 # Space around the players in pixels
var smoothing_speed : float
var position : Vector2

func set_value(property: String, new_value) -> void:
	set(property, new_value)
	value_changed.emit(property, new_value)

func _set_initial_camera_values_sp() -> void:
	#position = Vector2.ZERO
	smoothing_speed = 5.0
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
