extends TextEdit

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	text = "Wall Jump Pushback: " + str(InputsData.wall_jump_pushback)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var regex = RegEx.new()
	# Regex pattern matches an optional negative sign followed by digits and a decimal point
	regex.compile("-?\\d+\\.?\\d+") 

	var result = regex.search(text)
	var first_float : float = 0.0
	if result:
		first_float = result.get_string().to_float()

	InputsData.wall_jump_pushback = first_float

func _input(event: InputEvent):
	# Check if a mouse button is clicked while the node has focus
	if has_focus() and event is InputEventMouseButton and event.pressed:
		# If the click position is outside the node's rectangle
		if not get_global_rect().has_point(event.position):
			release_focus()
