extends Node

class_name LevelsDatabase

static var LEVEL_SCENES : Array[String] = []
static var levelNodes : Array[Node2D]

static var xLevelOffset : float = 0.0
static var yLevelOffset : float = 0.0

static var levelsCount : int = 0
static var maxHeight : int = 0

static var xLevelCenter : float = 0.0
static var yLevelCenter : float = 0.0

static var currLevel : int = 0

static func _load_level_scenes() -> void:
	LEVEL_SCENES.clear()
	var dir := DirAccess.open("res://Levels")
	if dir == null:
		push_error("LevelsDatabase: Could not open res://Levels directory.")
		return

	var level_regex := RegEx.new()
	level_regex.compile("^level_(\\d{2})\\.tscn$")

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and level_regex.search(file_name):
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

	if SaveLoadHelper.fileExist:
		currLevel = SaveLoadHelper.save_data.get("game", 1).get("level", 1).get("current", 1) - 1
	else:
		#Value starts at 0 not 1 for the array!
		currLevel = 0

	levelsCount = LEVEL_SCENES.size()
	maxHeight = 10
	print("All Levels Loaded!")

static func _level_switcher(newLevelNum : int = -1) -> void:
	print("---------------")
	print("Level Switched to: ", newLevelNum)

	if newLevelNum < 0:
		#Normal internal function of level switching incrementally.
		LevelsDatabase.currLevel += 1
	else:
		#Setting level forcibly to switch version.
		LevelsDatabase.currLevel = newLevelNum
	InputsData.begin_delay = true
	InputsData._reset_values()
	CameraHelper._reset_values_sp()

	if LevelsDatabase.currLevel >= LevelsDatabase.levelsCount:
		#print("Game Complete")
		return

	for k in PlayersHelper.playerNodes.size():
		PlayersHelper.clear_ghosts_for_player(k)
		PlayersHelper.playerNodes[k].get_child(0).position = Vector2(0.0, 0.0)
		PlayersHelper.playerNodes[k].global_position = LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position
		PlayersHelper.playerNodes[k].get_child(0)._start_new_run()

	SaveLoadHelper.save_game()
	print("---------------")
