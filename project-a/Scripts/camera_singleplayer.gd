extends Camera2D

@export var left_inset : float
@export var right_inset : float
@export var top_inset : float
@export var bottom_inset : float

@export var rectColor : Color
@export var lineBaseColor : Color
@export var lineHighlightedColor : Color

@export var circleColor : Color
@export var circleBaseColor : Color
@export var circleHighlightedColor : Color

@export var lineColorLeft : Color
@export var lineColorRight : Color
@export var lineColorTop : Color
@export var lineColorBottom : Color

@export var playerNode : Node2D
@export var playerPos : Vector2

@export var insetStartPos : Vector2
@export var insetSize : Vector2

@export var rectBounds : Rect2

@export var leftLine : Line2D
@export var rightLine : Line2D
@export var topLine : Line2D
@export var bottomLine : Line2D

@export var crossingLeft : bool
@export var crossingRight : bool
@export var crossingTop : bool
@export var crossingBottom : bool

@export var priorGlobalPos : Vector2
@export var priorInsetStartPos : Vector2
@export var priorInsetSize : Vector2
@export var priorPlayerPos : Vector2

@export var currLevel : Node2D
@export var camInset : Node2D

func _ready():
	CameraHelper._set_initial_camera_values_sp()

	priorGlobalPos = Vector2.ZERO
	priorInsetStartPos = Vector2.ZERO
	priorInsetSize = Vector2.ZERO
	priorPlayerPos = Vector2.ZERO

func _process(_delta : float):
	if PlayersHelper.playerNodes.is_empty():
		print("No players to play!")
		return

	if PlayersHelper.playerNodes.size() > 1:
		print("Multiple players in Single Player Mode!")
		return

	if playerNode == null:
		playerNode = PlayersHelper.playerNodes[0]
		playerPos = playerNode.get_child(0).global_position
		currLevel = LevelsDatabase.levelNodes[LevelsDatabase.currLevel]
		camInset = currLevel.get_child(3)
		return

	CameraHelper.left_inset = left_inset
	CameraHelper.right_inset = right_inset
	CameraHelper.top_inset = top_inset
	CameraHelper.bottom_inset = bottom_inset

	lineColorLeft = lineBaseColor
	lineColorRight = lineBaseColor
	lineColorTop = lineBaseColor
	lineColorBottom = lineBaseColor
	circleColor = circleBaseColor

	priorGlobalPos = CameraHelper.position_cam
	priorInsetStartPos = insetStartPos
	priorInsetSize = insetSize
	priorPlayerPos = Vector2(playerPos.x, playerPos.y)

	global_position = global_position.lerp(CameraHelper.position_cam, CameraHelper.smoothing_speed * _delta)

	queue_redraw()

func _draw() -> void:
	draw_circle(Vector2.ZERO, 10, circleColor)
