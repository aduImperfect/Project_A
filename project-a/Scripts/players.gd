class_name PlayersHelper

const PLAYER_SCENE = preload("res://Scenes/player.tscn")

static var playerNodes : Array[Node2D] = []
static var numPlayers : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _set_player_info() -> void:
	numPlayers = 1
