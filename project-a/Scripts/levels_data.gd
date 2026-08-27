extends Node
# Registered as Autoload: LevelsDatabase

signal value_changed(property: String, new_value)

var LEVEL_SCENES : Array[String] = []
var levelNodes : Array[Node2D]

var xLevelOffset : float = 0.0
var yLevelOffset : float = 0.0

var levelsCount : int = 0
var maxHeight : int = 0

var xLevelCenter : float = 0.0
var yLevelCenter : float = 0.0

var currLevel : int = 0

func _load_level_scenes() -> void:
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

func _set_values() -> void:
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

	value_changed.emit("currLevel", currLevel)

func _level_switcher(newLevelNum : int = -1) -> void:
	print("---------------")
	print("Level Switched to: ", newLevelNum)

	if newLevelNum < 0:
		#Normal internal function of level switching incrementally.
		currLevel += 1
	else:
		#Setting level forcibly to switch version.
		currLevel = newLevelNum
	InputsData.begin_delay = true
	InputsData._reset_values()
	CameraHelper._reset_values_sp()

	value_changed.emit("currLevel", currLevel)

	if currLevel >= levelsCount:
		#print("Game Complete")
		return

	for k in levelsCount:
		levelNodes[k].global_position.x = 0.0
		levelNodes[k].global_position.y = 0.0
		levelNodes[k].z_index = -2000
	levelNodes[currLevel].z_index = 0

	for k in PlayersHelper.playerNodes.size():
		PlayersHelper.clear_ghosts_for_player(k)
		PlayersHelper.playerNodes[k].get_child(0).position = Vector2(0.0, 0.0)
		PlayersHelper.playerNodes[k].global_position = levelNodes[currLevel].get_child(0).global_position
		PlayersHelper.playerNodes[k].get_child(0)._start_new_run()


	for k in levelsCount:
		if k == currLevel:
			continue
		levelNodes[k].global_position.x = -9999.0
		levelNodes[k].global_position.y = -9999.0

	levelNodes[currLevel].get_child(1).set_deferred("monitoring", true)
	CameraHelper.position = levelNodes[currLevel].get_child(2).position

	SaveLoadHelper.save_game()
	print("---------------")
