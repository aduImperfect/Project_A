extends CharacterBody2D

@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var up_speed : float = 0.0
@export var horiz_speed : float = 0.0
@export var max_run_speed : float = 0.0

@export var max_up_speed : float = 0.0
@export var max_horiz_speed : float = 0.0

@export var up_speed_dec : float = 0.0
@export var horiz_speed_dec : float = 0.0

@export var up_speed_min : float = 0.0
@export var horiz_speed_min : float = 0.0

@export var up_speed_min_diff : float = 0.0
@export var horiz_speed_min_diff : float = 0.0

@export var is_moving : bool = false
@export var is_jumping : bool = false
@export var grounded : bool = true
@export var is_running : bool = true

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var WALL_SLIDE_SPEED = 100.0
@export var WALL_JUMP_PUSHBACK = 400.0
# --- Wall Jump Mechanics ---
@export var wall_jump_lock_timer = 0.0
@export var WALL_JUMP_LOCK_TIME = 0.10 # Time in seconds player control is locked

# Export this variable to change it in the Inspector for each player node
@export var player_id: int = 0

@export var jump_action: String
@export var move_left_action: String
@export var move_right_action: String
@export var run_action: String

# --- Ghost recording ---
var ghost_frames : PackedVector2Array = PackedVector2Array()
var run_start_global : Vector2 = Vector2.ZERO

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	up_speed = 0.0
	horiz_speed = 0.0
	max_up_speed = 500.0
	max_horiz_speed = 100.0
	max_run_speed = 250.0
	up_speed_dec = 100.0
	horiz_speed_dec = 100.0
	up_speed_min = 0.0
	horiz_speed_min = 0.0
	up_speed_min_diff = 0.1
	horiz_speed_min_diff = 0.1
	is_moving = false
	is_jumping = false
	grounded = true

	jump_action = "ui_jump_p" + str(player_id)
	move_left_action = "ui_left_p" + str(player_id)
	move_right_action = "ui_right_p" + str(player_id)
	run_action = "ui_run_p" + str(player_id)

	_start_new_run()
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if LevelsDatabase.currLevel == LevelsDatabase.numLevels:
		return

	if not is_moving:
		if horiz_speed < -horiz_speed_min_diff:
			horiz_speed += _delta * horiz_speed_dec
		elif  horiz_speed > horiz_speed_min_diff:
			horiz_speed -= _delta * horiz_speed_dec
		else:
			horiz_speed = horiz_speed_min

	if is_jumping and grounded:
		up_speed = max_up_speed
		grounded = false
	elif not grounded:
		if up_speed > up_speed_min_diff:
			up_speed -= _delta * up_speed_dec
		else:
			up_speed = up_speed_min

	_player_death()


func _physics_process(_delta: float) -> void:
	if Input.is_action_pressed(move_left_action):
		horiz_speed = -max_horiz_speed
		is_moving = true
	elif Input.is_action_pressed(move_right_action):
		horiz_speed = max_horiz_speed
		is_moving = true
	else:
		is_moving = false

	if Input.is_action_pressed(jump_action):
		is_jumping = true
	else:
		is_jumping = false

	if Input.is_action_pressed(run_action):
		if is_moving:
			if horiz_speed < 0.0:
				horiz_speed = -max_run_speed
			elif horiz_speed > 0.0:
				horiz_speed = max_run_speed
			is_running = true
		else:
			is_running = false
	else:
		is_running = false

	position.x += _delta * horiz_speed
	position.y -= _delta * up_speed

	if wall_jump_lock_timer > 0:
		wall_jump_lock_timer -= _delta

	if is_on_floor():
		if is_jumping:
			velocity.y = JUMP_VELOCITY
		else:
			pass
		grounded = true
		up_speed = up_speed_min
	else:
		if is_on_wall():
			if is_jumping:
				# Wall Jump: Use wall normal to push away
				velocity.x = get_wall_normal().x * WALL_JUMP_PUSHBACK
				velocity.y = JUMP_VELOCITY
				wall_jump_lock_timer = WALL_JUMP_LOCK_TIME
			if velocity.y > 0.0:
				# 1. Handle Wall Sliding
				velocity.y = min(velocity.y, WALL_SLIDE_SPEED)
		#Gravity fall! Times 2!
		velocity.y += gravity * _delta * 2
		grounded = false

	# 3. Handle Horizontal Movement (with control lock)
	if wall_jump_lock_timer <= 0:
		velocity.x = horiz_speed
	else:
		# Air control during wall jump lock (optional, keeps inertia)
		velocity.x = move_toward(velocity.x, 0, 50)

	move_and_slide()

	ghost_frames.append(position)

func _input(_event: InputEvent) -> void:
	pass

func _player_death() -> void:
	if position.y > 250.0:
		#print("Current Level: ", LevelsDatabase.currLevel + 1)
		if ghost_frames.size() > 0:
			PlayersHelper.record_ghost_run(player_id, run_start_global, ghost_frames)

		position = Vector2(0.0, 0.0)
		owner.global_position = LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position
		up_speed = 0.0
		horiz_speed = 0.0
		is_moving = false
		is_jumping = false

		_start_new_run()
		#print("Player Died!")

func _start_new_run() -> void:
	ghost_frames = PackedVector2Array()
	run_start_global = owner.global_position
