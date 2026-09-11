extends Camera2D

@export var left_inset : float
@export var right_inset : float
@export var top_inset : float
@export var bottom_inset : float

@export var rectColor : Color
@export var playerNode : Node2D

func _ready():
	CameraHelper._set_initial_camera_values_sp()

func _process(_delta : float):
	if PlayersHelper.playerNodes.is_empty():
		print("No players to play!")
		return

	if PlayersHelper.playerNodes.size() > 1:
		print("Multiple players in Single Player Mode!")
		return

	if playerNode == null:
		playerNode = PlayersHelper.playerNodes[0]

	CameraHelper.left_inset = left_inset
	CameraHelper.right_inset = right_inset
	CameraHelper.top_inset = top_inset
	CameraHelper.bottom_inset = bottom_inset

	var center = playerNode.get_child(0).global_position
	CameraHelper.position = CameraHelper.position.lerp(center, CameraHelper.smoothing_speed * _delta)

	global_position = CameraHelper.position
	queue_redraw()

func _draw() -> void:
	var startPosX : float = global_position.x - left_inset
	var startPosY : float = global_position.y - top_inset
	var width : float = (global_position.x + right_inset) - (global_position.x - left_inset)
	var height : float = (global_position.y + bottom_inset) - (global_position.y - top_inset)
	var rectBounds : Rect2 = Rect2(startPosX, startPosY, width, height)
	draw_rect(rectBounds, rectColor)
