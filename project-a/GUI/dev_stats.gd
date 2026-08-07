extends RichTextLabel
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.
# Function to round a float to a given number of decimal places

func _round_to_decimals(value: float, decimals: int) -> float:
	var factor := pow(10, decimals)  # e.g., 10^2 = 100 for 2 decimals
	return round(value * factor) / factor

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var numPlayers = "Players: " + str(PlayersHelper.playersCount)
	var fpsCount = "FPS: " + str(Engine.get_frames_per_second())
	var gamepad = "Gamepad?: " + str(InputsData.is_using_gamepad)
	var jumpSpeed = "Jump Speed: " + str(_round_to_decimals(InputsData.jump_speed, 2))
	var moveSpeed = "Move Speed: " + str(_round_to_decimals(InputsData.move_speed, 2))
	var beginDelay = "Begin Delay: " + str(InputsData.begin_delay)
	text = numPlayers + "\n" + fpsCount + "\n" + gamepad + "\n" + jumpSpeed + "\n" + moveSpeed + "\n" + beginDelay
