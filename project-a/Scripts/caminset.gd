extends Node2D

class_name CameraInset

@export var normalTex : Texture2D
@export var highlightedTex : Texture2D

@export var size : Vector2
#@export var cam_speed : float

static var insetSet : bool
static var playerNode : Node2D
static var playerPos : Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if LevelsDatabase.levelNodes.is_empty():
		return

	if (!LevelsDatabase.levelNodes.is_empty()) && (insetSet == false):
		playerNode = PlayersHelper.playerNodes[0]
		playerPos = playerNode.get_child(0).global_position
		insetSet = true
		return

	playerPos = playerNode.get_child(0).global_position
	get_child(0).scale = size

	if (owner.global_position.x < -9000) || (owner.global_position.y < -9000):
		return

	#print(owner.name)

	# LEFT INSET
	if (playerPos.x <= (global_position.x - (size.x / 2))):
		get_child(0).get_child(0).texture = highlightedTex
		global_position.x += _delta * InputsData.move_speed
		CameraHelper.position_cam.x += _delta * InputsData.move_speed
		#print("Player past left inset. Player at: ", playerPos, " and inset at ", global_position)
		
	else:
		get_child(0).get_child(0).texture = normalTex
		CameraHelper.position_cam.x -= 0.0

	# RIGHT INSET
	if (playerPos.x >= (global_position.x + (size.x / 2))):
		get_child(0).get_child(1).texture = highlightedTex
		global_position.x += _delta * InputsData.move_speed
		CameraHelper.position_cam.x += _delta * InputsData.move_speed
		#print("Player past right inset. Player at: ", playerPos, " and inset at ", global_position)
	else:
		get_child(0).get_child(1).texture = normalTex
		CameraHelper.position_cam.x += 0.0

	# TOP INSET
	if (playerPos.y <= (global_position.y - (size.y / 2))):
		get_child(0).get_child(2).texture = highlightedTex
		global_position.y -= _delta * InputsData.jump_speed
		CameraHelper.position_cam.y -= _delta * InputsData.jump_speed
		#print("Player past top inset. Player at: ", playerPos, " and inset at ", global_position)
	else:
		get_child(0).get_child(2).texture = normalTex
		CameraHelper.position_cam.y -= 0.0

	# BOTTOM INSET
	if (playerPos.y >= (global_position.y + (size.y / 2))):
		get_child(0).get_child(3).texture = highlightedTex
		global_position.y += _delta * InputsData.jump_speed
		CameraHelper.position_cam.y += _delta * InputsData.jump_speed
		#print("Player past bottom inset. Player at: ", playerPos, " and inset at ", global_position)
	else:
		get_child(0).get_child(3).texture = normalTex
		CameraHelper.position_cam.y += 0.0

	queue_redraw()

func _draw() -> void:
	draw_line(Vector2.ZERO, playerPos - global_position, Color(1.0,1.0, 1.0, 1.0), 2.0)
