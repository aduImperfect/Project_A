extends Node

class_name LevelsDatabase

static var LEVEL_SCENES : Array[String] = []
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

static func _load_level_scenes() -> void:
	LEVEL_SCENES.clear()
	var dir := DirAccess.open("res://Levels")
	if dir == null:
		push_error("LevelsDatabase: Could not open res://Levels directory.")
		return

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and file_name.ends_with(".tscn"):
			LEVEL_SCENES.append("res://Levels/%s" % file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	LEVEL_SCENES.sort()

static func _set_values() -> void:
	_load_level_scenes()

	xLevelCenter = 0.0
	yLevelCenter = 0.0

	xLevelOffset = 3000.0
	yLevelOffset = 2000.0

	currLevel = 0
	numLevels = LEVEL_SCENES.size()
	maxHeight = 10
