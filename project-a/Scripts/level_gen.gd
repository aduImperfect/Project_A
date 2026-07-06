extends Node2D

const PLAYER_SCENE = preload("res://Scenes/player.tscn")
const BACKGROUND_SCENE = preload("res://Scenes/background.tscn")

@export var xBackCenter : float = 0.0
@export var yBackCenter : float = 0.0

@export var playerNode : Node2D
@export var backgroundNode : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xBackCenter = 550.0
	yBackCenter = 350.0

	LevelsDatabase._set_values()
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
	for k in LevelsDatabase.numLevels:
		var level_instance = load(LevelsDatabase.LEVEL_SCENES[k]).instantiate()
		level_instance.global_position.x = LevelsDatabase.xLevelCenter + (j * LevelsDatabase.xLevelOffset)
		level_instance.global_position.y = LevelsDatabase.yLevelCenter + (k * LevelsDatabase.yLevelOffset)
		add_child(level_instance)
		LevelsDatabase.levelNodes.append(level_instance)

		if j < (LevelsDatabase.maxHeight - 1):
			j += 1
		else:
			j = 0

func _spawn_player() -> void:
	var player_instance = PLAYER_SCENE.instantiate()
	player_instance.global_position = LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position
	add_child(player_instance)
	playerNode = player_instance
