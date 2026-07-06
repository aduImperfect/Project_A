extends Node2D

const PLAYER_SCENE = preload("res://Scenes/player.tscn")
const BACKGROUND_SCENE = preload("res://Scenes/background.tscn")
const LEVEL_SCENE = preload("res://Scenes/level_1.tscn")

@export var xBackCenter : float = 0.0
@export var yBackCenter : float = 0.0

@export var xLevel1Center : float = 0.0
@export var yLevel1Center : float = 0.0

@export var xPCenter : float = 0.0
@export var yPCenter : float = 0.0

@export var playerNode : Node2D
@export var backgroundNode : Node2D
@export var level1Node : Node2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	xBackCenter = 550.0
	yBackCenter = 350.0

	xLevel1Center = 0.0
	yLevel1Center = 0.0

	xPCenter = 50.0
	yPCenter = 550.0

	_spawn_background()
	_spawn_level1()
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

func _spawn_level1() -> void:
	var level1_instance = LEVEL_SCENE.instantiate()
	level1_instance.global_position.x = xLevel1Center
	level1_instance.global_position.y = yLevel1Center
	add_child(level1_instance)
	level1Node = level1_instance

func _spawn_player() -> void:
	var player_instance = PLAYER_SCENE.instantiate()
	player_instance.global_position.x = xPCenter
	player_instance.global_position.y = yPCenter
	add_child(player_instance)
	playerNode = player_instance
