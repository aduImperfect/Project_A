class_name AudioDatabase

static var AUDIO_SCENES : Array[String] = []
static var audioNodes : Array[Node2D]
static var audioCount : int = 0

static func _load_audio_scenes() -> void:
	AUDIO_SCENES.clear()
	var dir := DirAccess.open("res://Audio")
	if dir == null:
		push_error("AudioDatabase: Could not open res://Audio directory.")
		return

	var audio_regex := RegEx.new()
	audio_regex.compile("^audio_(\\d{2})\\.tscn$")

	dir.list_dir_begin()
	var file_name := dir.get_next()
	while file_name != "":
		if not dir.current_is_dir() and audio_regex.search(file_name):
			AUDIO_SCENES.append("res://Audio/%s" % file_name)
		file_name = dir.get_next()
	dir.list_dir_end()

	AUDIO_SCENES.sort()

static func _set_values() -> void:
	_load_audio_scenes()
	audioCount = AUDIO_SCENES.size()
	print("All Audio Loaded!")

func _reset_values() -> void:
	pass
