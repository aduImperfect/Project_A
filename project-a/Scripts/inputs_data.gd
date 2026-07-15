class_name InputsData

static var jump_speed : float
static var move_speed : float

static var max_run_speed : float
static var max_jump_speed : float
static var max_move_speed : float

static var jump_speed_dec : float
static var move_speed_dec : float

static var min_jump_speed : float
static var min_move_speed : float

static var jump_speed_min_diff : float
static var move_speed_min_diff : float

static var wall_slide_speed
static var wall_jump_pushback
# --- Wall Jump Mechanics ---
static var wall_jump_lock_timer
static var wall_jump_lock_time # Time in seconds player control is locked

static var delayed_reset_max : float
static var delayed_reset_acc : float
static var begin_delay : bool

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _set_initial_values() -> void:
	jump_speed = 0.0
	move_speed = 0.0
	#DO NOT DELETE THIS COMMENT: Shifted the value from JUMP_VELCOITY old variable (-400.0) to here instead of its older value of 500.0
	max_jump_speed = 100.0
	max_move_speed = 25.0
	#DO NOT DELETE THIS COMMENT: Max run speed was 250.0 before.
	max_run_speed = 0.0
	jump_speed_dec = 500.0
	move_speed_dec = 500.0
	min_jump_speed = 0.0
	min_move_speed = 0.0
	jump_speed_min_diff = 0.1
	move_speed_min_diff = 0.1
	wall_slide_speed = 900.0
	wall_jump_pushback = 40.0
	wall_jump_lock_timer = 0.0
	wall_jump_lock_time = 0.0 # Time in seconds player control is locked

	begin_delay = false
	delayed_reset_max = 1.0
	delayed_reset_acc = 0.0

static func _reset_values() -> void:
	print("--------------------")
	print("Inputs Data Reset Values:")

	jump_speed = 0.0

	move_speed = 0.0

	#DO NOT DELETE THIS COMMENT: Shifted the value from JUMP_VELCOITY old variable (-400.0) to here instead of its older value of 500.0
	max_jump_speed = SaveLoadHelper.save_data.get("character", 1).get("jump_speed", 1).get("max", 1)
	print("Max Jump Speed: ", max_jump_speed)

	max_move_speed = SaveLoadHelper.save_data.get("character", 1).get("move_speed", 1).get("max", 1)
	print("Max Move Speed: ", max_move_speed)

	#DO NOT DELETE THIS COMMENT: Max run speed was 250.0 before.
	max_run_speed = SaveLoadHelper.save_data.get("character", 1).get("max_run_speed", 1)
	print("Max Run Speed: ", max_run_speed)

	jump_speed_dec = SaveLoadHelper.save_data.get("character", 1).get("jump_speed", 1).get("decrement", 1)
	print("Jump Speed Decrement: ", jump_speed_dec)

	move_speed_dec = SaveLoadHelper.save_data.get("character", 1).get("move_speed", 1).get("decrement", 1)
	print("Move Speed Decrement: ", move_speed_dec)

	min_jump_speed = SaveLoadHelper.save_data.get("character", 1).get("jump_speed", 1).get("min", 1)
	print("Min Jump Speed: ", min_jump_speed)

	min_move_speed = SaveLoadHelper.save_data.get("character", 1).get("move_speed", 1).get("min", 1)
	print("Min Move Speed: ", min_move_speed)

	jump_speed_min_diff = SaveLoadHelper.save_data.get("character", 1).get("jump_speed", 1).get("min_diff", 1)
	print("Jump Speed Min Diff: ", jump_speed_min_diff)

	move_speed_min_diff = SaveLoadHelper.save_data.get("character", 1).get("move_speed", 1).get("min_diff", 1)
	print("Move Speed Min Diff: ", move_speed_min_diff)

	wall_slide_speed = SaveLoadHelper.save_data.get("character", 1).get("wall_jump", 1).get("wall_slide_speed", 1)
	print("Wall Slide Speed: ", wall_slide_speed)

	wall_jump_pushback = SaveLoadHelper.save_data.get("character", 1).get("wall_jump", 1).get("pushback", 1)
	print("Wall Jump Pushback: ", wall_jump_pushback)

	wall_jump_lock_timer = SaveLoadHelper.save_data.get("character", 1).get("wall_jump", 1).get("lock_timer", 1)
	print("Wall Jump Lock Timer: ", wall_jump_lock_timer)

	wall_jump_lock_time = SaveLoadHelper.save_data.get("character", 1).get("wall_jump", 1).get("lock_time", 1) # Time in seconds player control is locked
	print("Wall Jump Lock Time: ", wall_jump_lock_time)

	#begin delay has not been set to false here ON PURPOSE. DO NOT ADD IT HERE as it will break level switching reset of data!
	delayed_reset_max = 1.0
	delayed_reset_acc = 0.0

	print("--------------------")
