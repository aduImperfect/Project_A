extends RichTextLabel


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var numPlayers = "Players: " + str(PlayersHelper.playersCount)
	var fpsCount = "FPS: " + str(Engine.get_frames_per_second())
	var gamepad = "Gamepad?: " + str(InputsData.is_using_gamepad)
	var jumpSpeed = "Jump Speed: " + str(int(InputsData.jump_speed))
	var moveSpeed = "Move Speed: " + str(InputsData.move_speed)
	var beginDelay = "Begin Delay: " + str(InputsData.begin_delay)
	text = numPlayers + "\n" + fpsCount + "\n" + gamepad + "\n" + jumpSpeed + "\n" + moveSpeed + "\n" + beginDelay
