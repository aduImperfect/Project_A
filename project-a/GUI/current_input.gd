extends TextEdit

var input_history: Array[String] = []
var last_input: String = ""

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	editable = false
	wrap_mode = TextEdit.LINE_WRAPPING_BOUNDARY

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	var current_input := str(InputsData.current_player_input_text)

	# Only record it as a "new" entry if it actually changed
	if current_input != last_input and current_input != "":
		input_history.push_front(current_input)  # add to the front (most recent first)

		if input_history.size() > 10:
			input_history.resize(10)  # keep only the last 10

		last_input = current_input
		text = "\n".join(input_history)

func _input(event: InputEvent) -> void:
	# Check if a mouse button is clicked while the node has focus
	if has_focus() and event is InputEventMouseButton and event.pressed:
		# If the click position is outside the node's rectangle
		if not get_global_rect().has_point(event.position):
			release_focus()
