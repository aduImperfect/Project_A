class_name SaveLoadHelper

# Always use "user://" because "res://" is read-only in exported games
const DATA_DIR = "user://Data"
const SAVE_PATH = "user://Data/save_game.json"

static var fileExist : bool = false
static var initialVars : bool = false

static func _file_checker() -> void:
	if not FileAccess.file_exists(SAVE_PATH):
		fileExist = false
	else:
		fileExist = true

# 1. SAVE FUNCTION
static func save_game() -> void:
	# Build a plain Dictionary with your variables
	# Note: Godot types like Vector2 must be broken down into primitive numbers
	var save_data = {
		#Players Data
		"nummber_of_players": PlayersHelper.numPlayers,
		#Levels Data
		"number_of_levels" : LevelsDatabase.numLevels,
		"current_level" : LevelsDatabase.currLevel + 1,
		#Inputs Data
		"minimum_jump_speed" : InputsData.min_jump_speed,
		"minimum_move_speed" : InputsData.min_move_speed,
		"maximum_jump_speed" : InputsData.max_jump_speed,
		"maximum_move_speed" : InputsData.max_move_speed,
		"maximum_run_speed" : InputsData.max_run_speed,
		"jump_speed_decrement" : InputsData.jump_speed_dec,
		"move_speed_decrement" : InputsData.move_speed_dec,
		"jump_speed_minimum_difference" : InputsData.jump_speed_min_diff,
		"move_speed_minimum_difference" : InputsData.move_speed_min_diff,
		"wall_slide_speed" : InputsData.wall_slide_speed,
		"wall_jump_pushback" : InputsData.wall_jump_pushback,
		"wall_jump_lock_timer" : InputsData.wall_jump_lock_timer,
		"wall_jump_lock_time" : InputsData.wall_jump_lock_time,
	}

	# Check if the folder already exists
	if not DirAccess.dir_exists_absolute(DATA_DIR):
		var error = DirAccess.make_dir_recursive_absolute(DATA_DIR)
		if error == OK:
			print("Folder created successfully!")
		else:
			print("Failed to create folder. Error code: ", error)
	else:
		print("Folder: " + str(DATA_DIR) + " already exists!")

	# Open the file for writing
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)

	if file:
		# Convert the Dictionary to a JSON string
		var json_string = JSON.stringify(save_data)
		# Write it to the file
		file.store_line(json_string)
		file.close()
		print("Game Saved!")
		print("JSON file successfully created/updated at: ", ProjectSettings.globalize_path(SAVE_PATH))
		fileExist = true
	else:
		print("Failed to create file. Error code: ", FileAccess.get_open_error())
		fileExist = false



# 2. LOAD FUNCTION
static func load_game() -> void:
	# Check if the file exists before reading
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		print("Failed to open file to load!")
		fileExist = false
		return

	# Open the file for reading
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if file:
		var json_string = file.get_as_text()
		file.close()

		# Parse the string back into a usable Godot Dictionary
		var save_data = JSON.parse_string(json_string)
		
		# Check if parsing was successful
		if save_data == null:
			print("Error parsing JSON string.")
			return

		# Apply the loaded values back to your variables
		#Players Data
		PlayersHelper.numPlayers = int(save_data.get("nummber_of_players", 1))
		#Levels Data
		LevelsDatabase.numLevels = int(save_data.get("nummber_of_levels", 1))
		LevelsDatabase.currLevel = int(save_data.get("current_level", 1)) - 1
		#Inputs Data
		InputsData.min_jump_speed = int(save_data.get("minimum_jump_speed", 1))
		InputsData.min_move_speed = int(save_data.get("minimum_move_speed", 1))
		InputsData.max_jump_speed = int(save_data.get("maximum_jump_speed", 1))
		InputsData.max_move_speed = int(save_data.get("maximum_move_speed", 1))
		InputsData.max_run_speed = int(save_data.get("maximum_run_speed", 1))
		InputsData.jump_speed_dec = int(save_data.get("jump_speed_decrement", 1))
		InputsData.move_speed_dec = int(save_data.get("move_speed_decrement", 1))
		InputsData.jump_speed_min_diff = int(save_data.get("jump_speed_minimum_difference", 1))
		InputsData.move_speed_min_diff = int(save_data.get("move_speed_minimum_difference", 1))
		InputsData.wall_slide_speed = int(save_data.get("wall_slide_speed", 1))
		InputsData.wall_jump_pushback = int(save_data.get("wall_jump_pushback", 1))
		InputsData.wall_jump_lock_timer = int(save_data.get("wall_jump_lock_timer", 1))
		InputsData.wall_jump_lock_time = int(save_data.get("wall_jump_lock_time", 1))
		print("Game Loaded!")
		fileExist = true
	else:
		fileExist = false
