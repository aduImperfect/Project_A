class_name SaveLoadHelper

# Always use "user://" because "res://" is read-only in exported games
const DATA_DIR = "user://Data"
const SAVE_PATH = "user://Data/save_game.json"

# 1. SAVE FUNCTION
static func save_game() -> void:
	# Build a plain Dictionary with your variables
	# Note: Godot types like Vector2 must be broken down into primitive numbers
	var save_data = {
		"nummber_of_players": PlayersHelper.numPlayers,
		"number_of_levels" : LevelsDatabase.numLevels,
		"current_level" : LevelsDatabase.currLevel,
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
	else:
		print("Failed to create file. Error code: ", FileAccess.get_open_error())



# 2. LOAD FUNCTION
static func load_game() -> void:
	# Check if the file exists before reading
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
		print("Failed to open file to load!")
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
		PlayersHelper.numPlayers = int(save_data.get("nummber_of_players", 1))
		LevelsDatabase.numLevels = int(save_data.get("nummber_of_levels", 1))
		LevelsDatabase.currLevel = int(save_data.get("current_level", 1))
		print("Game Loaded!")
