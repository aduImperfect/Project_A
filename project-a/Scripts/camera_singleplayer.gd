extends Camera2D

@export var left_inset : float
@export var right_inset : float
@export var top_inset : float
@export var bottom_inset : float

@export var rectColor : Color
@export var lineBaseColor : Color
@export var lineHighlightedColor : Color

@export var lineColorLeft : Color
@export var lineColorRight : Color
@export var lineColorTop : Color
@export var lineColorBottom : Color

@export var playerNode : Node2D

@export var startPosX : float
@export var startPosY : float
@export var width : float
@export var height : float

@export var rectBounds : Rect2

@export var leftLine : Line2D
@export var rightLine : Line2D
@export var topLine : Line2D
@export var bottomLine : Line2D

@export var crossingLeft : bool
@export var crossingRight : bool
@export var crossingTop : bool
@export var crossingBottom : bool

func _ready():
	CameraHelper._set_initial_camera_values_sp()
	startPosX = global_position.x - left_inset
	startPosY = global_position.y - top_inset
	width = (global_position.x + right_inset) - (global_position.x - left_inset)
	height = (global_position.y + bottom_inset) - (global_position.y - top_inset)

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

	var playerPos = playerNode.get_child(0).global_position
	CameraHelper.position = CameraHelper.position.lerp(playerPos, CameraHelper.smoothing_speed * _delta)

	lineColorLeft = lineBaseColor
	lineColorRight = lineBaseColor
	lineColorTop = lineBaseColor
	lineColorBottom = lineBaseColor

	if (InputsData.move_speed < 0) && (playerPos.x <= startPosX):
		lineColorLeft = lineHighlightedColor
		startPosX = playerPos.x
		#global_position.x += _delta * InputsData.move_speed
	elif (InputsData.move_speed > 0) && (playerPos.x >= (startPosX + width)):
		lineColorRight = lineHighlightedColor
		startPosX = playerPos.x - width
		#global_position.x += _delta * InputsData.move_speed

	if playerPos.y <= startPosY:
		lineColorTop = lineHighlightedColor
		startPosY = playerPos.y
	elif playerPos.y >= (startPosY + height):
		lineColorBottom = lineHighlightedColor
		startPosY = playerPos.y - height

	rectBounds = Rect2(startPosX, startPosY, width, height)
	queue_redraw()

func _draw() -> void:
	draw_rect(rectBounds, rectColor, false)
	draw_line(Vector2(startPosX, startPosY), Vector2(startPosX, startPosY + height), lineColorLeft)
	draw_line(Vector2(startPosX + width, startPosY), Vector2(startPosX + width, startPosY + height), lineColorRight)
	draw_line(Vector2(startPosX, startPosY), Vector2(startPosX + width, startPosY), lineColorTop)
	draw_line(Vector2(startPosX, startPosY + height), Vector2(startPosX + width, startPosY + height), lineColorBottom)
