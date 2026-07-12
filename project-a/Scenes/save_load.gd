class_name SaveLoadHelper

# Always use "user://" because "res://" is read-only in exported games
const SAVE_PATH = "user://Data/save_game.json"

# Variables we want to save
static var player_level: int = 1
static var player_coins: int = 150
static var player_name: String = "Hero"
static var player_position: Vector2 = Vector2(100, 250)

# 1. SAVE FUNCTION
static func save_game() -> void:
	# Build a plain Dictionary with your variables
	# Note: Godot types like Vector2 must be broken down into primitive numbers
	var save_data = {
		"player_name": player_name,
		"player_level": player_level,
		"player_coins": player_coins,
		"pos_x": player_position.x,
		"pos_y": player_position.y
	}
	
	# Open the file for writing
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	if file:
		# Convert the Dictionary to a JSON string
		var json_string = JSON.stringify(save_data)
		# Write it to the file
		file.store_line(json_string)
		file.close()
		print("Game Saved!")


# 2. LOAD FUNCTION
static func load_game() -> void:
	# Check if the file exists before reading
	if not FileAccess.file_exists(SAVE_PATH):
		print("No save file found.")
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
		player_name = save_data.get("player_name", "Hero")
		player_level = int(save_data.get("player_level", 1))
		player_coins = int(save_data.get("player_coins", 0))
		
		# Rebuild your Vector2 from the primitive numbers
		var pos_x = save_data.get("pos_x", 0.0)
		var pos_y = save_data.get("pos_y", 0.0)
		player_position = Vector2(pos_x, pos_y)
		
		print("Game Loaded!")
