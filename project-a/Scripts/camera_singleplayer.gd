extends Camera2D

func _ready():
	CameraHelper._set_initial_camera_values_sp()

func _process(_delta : float):
	if PlayersHelper.playerNodes.is_empty():
		print("No players to play!")
		return

	if PlayersHelper.playerNodes.size() > 1:
		print("Multiple players in Single Player Mode!")
		return

	# 1. Find the center point
	var center = Vector2.ZERO
	center += PlayersHelper.playerNodes[0].get_child(0).global_position

	# Smoothly move and zoom
	global_position = global_position.lerp(center, CameraHelper.smoothing_speed * _delta)
