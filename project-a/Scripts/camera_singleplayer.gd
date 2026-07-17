extends Camera2D

# Camera settings
@export var smoothing_speed = 5.0

func _ready():
	pass

func _process(delta):
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
	global_position = global_position.lerp(center, smoothing_speed * delta)
