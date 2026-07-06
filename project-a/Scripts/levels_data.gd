extends Node

class_name LevelsDatabase

const LEVEL_SCENES : Array[String] = ["res://Scenes/level_1.tscn", "res://Scenes/level_2.tscn", "res://Scenes/level_3.tscn"]
static var levelNodes : Array[Node2D]

static var xLevelOffset : float = 0.0
static var yLevelOffset : float = 0.0

static var numLevels : int = 0
static var maxHeight : int = 0

static var xLevelCenter : float = 0.0
static var yLevelCenter : float = 0.0

static var currLevel : int = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _set_values() -> void:
	xLevelCenter = 0.0
	yLevelCenter = 0.0
	
	xLevelOffset = 3000.0
	yLevelOffset = 2000.0

	currLevel = 0
	numLevels = 3
	maxHeight = 10
