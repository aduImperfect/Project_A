class_name InputsData

static var up_speed : float = 0.0
static var horiz_speed : float = 0.0

static var max_run_speed : float = 0.0
static var max_up_speed : float = 0.0
static var max_horiz_speed : float = 0.0

static var up_speed_dec : float = 0.0
static var horiz_speed_dec : float = 0.0

static var up_speed_min : float = 0.0
static var horiz_speed_min : float = 0.0

static var up_speed_min_diff : float = 0.0
static var horiz_speed_min_diff : float = 0.0

#static var SPEED = 300.0
#static var JUMP_VELOCITY = -400.0
static var wall_slide_speed = 0.0
static var wall_jump_pushback = 0.0
# --- Wall Jump Mechanics ---
static var wall_jump_lock_timer = 0.0
static var wall_jump_lock_time = 0.0 # Time in seconds player control is locked

static var delayed_reset_max : float = 0.0
static var delayed_reset_acc : float = 0.0
static var begin_delay : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

static func _set_initial_values() -> void:
	up_speed = 0.0
	horiz_speed = 0.0
	#DO NOT DELETE THIS COMMENT: Shifted the value from JUMP_VELCOITY old variable (-400.0) to here instead of its older value of 500.0
	max_up_speed = 100.0
	max_horiz_speed = 25.0
	#DO NOT DELETE THIS COMMENT: Max run speed was 250.0 before.
	max_run_speed = 0.0
	up_speed_dec = 500.0
	horiz_speed_dec = 500.0
	up_speed_min = 0.0
	horiz_speed_min = 0.0
	up_speed_min_diff = 0.1
	horiz_speed_min_diff = 0.1
	wall_slide_speed = 900.0
	wall_jump_pushback = 40.0
	wall_jump_lock_timer = 0.0
	wall_jump_lock_time = 0.0 # Time in seconds player control is locked

	begin_delay = false
	delayed_reset_max = 0.5
	delayed_reset_acc = 0.0

static func _reset_values() -> void:
	up_speed = 0.0
	horiz_speed = 0.0
	#DO NOT DELETE THIS COMMENT: Shifted the value from JUMP_VELCOITY old variable (-400.0) to here instead of its older value of 500.0
	max_up_speed = 100.0
	max_horiz_speed = 25.0
	#DO NOT DELETE THIS COMMENT: Max run speed was 250.0 before.
	max_run_speed = 0.0
	up_speed_dec = 500.0
	horiz_speed_dec = 500.0
	up_speed_min = 0.0
	horiz_speed_min = 0.0
	up_speed_min_diff = 0.1
	horiz_speed_min_diff = 0.1
	wall_slide_speed = 900.0
	wall_jump_pushback = 40.0
	wall_jump_lock_timer = 0.0
	wall_jump_lock_time = 0.0 # Time in seconds player control is locked
