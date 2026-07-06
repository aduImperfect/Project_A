extends Node2D

const PLAYER_SCENE = preload("res://Scenes/player.tscn")
const BACKGROUND_SCENE = preload("res://Scenes/background.tscn")

const LEVEL_SCENES : Array[String] = ["res://Scenes/level_1.tscn", "res://Scenes/level_2.tscn"]

@export var xBackCenter : float = 0.0
@export var yBackCenter : float = 0.0

@export var xLevelCenter : float = 0.0
@export var yLevelCenter : float = 0.0

@export var playerNode : Node2D
@export var backgroundNode : Node2D
@export var levelNodes : Array[Node2D]

@export var xLevelOffset : float = 0.0
@export var yLevelOffset : float = 0.0

@export var numLevels : int = 0
@export var maxHeight : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xBackCenter = 550.0
	yBackCenter = 350.0

	xLevelCenter = 0.0
	yLevelCenter = 0.0
	
	xLevelOffset = 3000.0
	yLevelOffset = 2000.0

	numLevels = 2
	maxHeight = 10

	_spawn_background()
	_spawn_levels()
	_spawn_player()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _spawn_background() -> void:
	var background_instance = BACKGROUND_SCENE.instantiate()
	background_instance.global_position.x = xBackCenter
	background_instance.global_position.y = yBackCenter
	add_child(background_instance)
	backgroundNode = background_instance

func _spawn_levels() -> void:
	var j : int = 0
	for k in numLevels:
		var level_instance = load(LEVEL_SCENES[k]).instantiate()
		level_instance.global_position.x = xLevelCenter + (j * xLevelOffset)
		level_instance.global_position.y = yLevelCenter + (k * yLevelOffset)
		add_child(level_instance)
		levelNodes.append(level_instance)

		if j < (maxHeight - 1):
			j += 1
		else:
			j = 0

func _spawn_player() -> void:
	var player_instance = PLAYER_SCENE.instantiate()
	player_instance.global_position.x = levelNodes[0].get_child(0).position.x
	player_instance.global_position.y = levelNodes[0].get_child(0).position.y
	add_child(player_instance)
	playerNode = player_instance
