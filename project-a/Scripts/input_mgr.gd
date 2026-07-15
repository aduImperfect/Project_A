@tool

extends CharacterBody2D

@export var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@export var is_moving : bool = false
@export var is_jumping : bool = false
@export var grounded : bool = true
@export var is_running : bool = true

@export var text_edit_input : bool = false

# Export this variable to change it in the Inspector for each player node
@export var player_id: int = 0

@export var jump_action: String
@export var move_left_action: String
@export var move_right_action: String
@export var run_action: String

# --- Ghost recording ---
var ghost_frames : PackedVector2Array = PackedVector2Array()
var run_start_global : Vector2 = Vector2.ZERO

@export var initializationAccumulationTime : float = 0.0
@export var initializationAccumulationTimer : float = 0.0
@export var initializationCommplete : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	initializationAccumulationTime = 0.0
	initializationAccumulationTimer = 0.25
	initializationCommplete = false

func _initialize() -> void:
	#If first time consideration of initialization from code needs to be given priority!
	#Lazy check only during first player initialization starting as the InputsData are common static values currently!
	if player_id == 0:
		if SaveLoadHelper.fileExist:
			InputsData._reset_values()
		else:
			InputsData._set_initial_values()

	is_moving = false
	is_jumping = false
	grounded = true

	jump_action = "ui_jump_p" + str(player_id)
	move_left_action = "ui_left_p" + str(player_id)
	move_right_action = "ui_right_p" + str(player_id)
	run_action = "ui_run_p" + str(player_id)

	_add_input_actions_for_this_player()

	#var inputActions : Array[StringName] = InputMap.get_actions()
#
	#print("-------------------------------")
	#print(player_id)
	#for k in inputActions.size():
		#if (inputActions[k] == jump_action) || (inputActions[k] == move_left_action) || (inputActions[k] == move_right_action) || (inputActions[k] == run_action):
			#print("Action Info: ")
			#print(inputActions[k])
			#var inpEvents : Array[InputEvent] = InputMap.action_get_events(inputActions[k])
			#for j in inpEvents.size():
				#print(inpEvents[j].as_text())
	#print("-------------------------------")

	_start_new_run()

	#Lazy check only during last player initialization finishing as the InputsData are common static values currently!
	if player_id == (PlayersHelper.playersCount - 1):
		initializationCommplete = true
		SaveLoadHelper.save_game()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if initializationCommplete == false:
		initializationAccumulationTime += _delta
		if initializationAccumulationTime > initializationAccumulationTimer:
			initializationAccumulationTime = 0.0
			_initialize()
		return

	#Only accumulate delay once for all players and not playerCount times!
	if InputsData.begin_delay && player_id == 0:
		InputsData.delayed_reset_acc += _delta
		if InputsData.delayed_reset_acc > InputsData.delayed_reset_max:
			InputsData.delayed_reset_acc = 0.0
			InputsData.begin_delay = false

	if text_edit_input:
		return

	if LevelsDatabase.currLevel == LevelsDatabase.levelsCount:
		return

	if not is_moving:
		if InputsData.move_speed < -InputsData.move_speed_min_diff:
			InputsData.move_speed += _delta * InputsData.move_speed_dec
		elif InputsData.move_speed > InputsData.move_speed_min_diff:
			InputsData.move_speed -= _delta * InputsData.move_speed_dec
		else:
			InputsData.move_speed = InputsData.min_move_speed

	if is_jumping and grounded:
		InputsData.jump_speed = InputsData.max_jump_speed
		grounded = false
	elif not grounded:
		if InputsData.jump_speed > InputsData.jump_speed_min_diff:
			InputsData.jump_speed -= _delta * InputsData.jump_speed_dec
		else:
			InputsData.jump_speed = InputsData.min_jump_speed

	_player_death()


func _physics_process(_delta: float) -> void:
	if initializationCommplete == false:
		return

	if text_edit_input:
		return

	if Input.is_action_pressed(move_left_action):
		InputsData.move_speed = -InputsData.max_move_speed
		is_moving = true
	elif Input.is_action_pressed(move_right_action):
		InputsData.move_speed = InputsData.max_move_speed
		is_moving = true
	else:
		is_moving = false

	if Input.is_action_pressed(jump_action):
		is_jumping = true
	else:
		is_jumping = false

	if Input.is_action_pressed(run_action):
		if is_moving:
			if InputsData.move_speed < 0.0:
				InputsData.move_speed = -InputsData.max_run_speed
			elif InputsData.move_speed > 0.0:
				InputsData.move_speed = InputsData.max_run_speed
			is_running = true
		else:
			is_running = false
	else:
		is_running = false

	position.x += _delta * InputsData.move_speed
	position.y -= _delta * InputsData.jump_speed

	if InputsData.wall_jump_lock_timer > 0:
		InputsData.wall_jump_lock_timer -= _delta

	if is_on_floor():
		if is_jumping:
			velocity.y = -(InputsData.max_jump_speed)
			pass
		else:
			pass
		grounded = true
		InputsData.jump_speed = InputsData.min_jump_speed
	else:
		if is_on_wall():
			if is_jumping:
				# Wall Jump: Use wall normal to push away
				velocity.x = get_wall_normal().x * InputsData.wall_jump_pushback
				velocity.y = -(InputsData.max_jump_speed)
				InputsData.wall_jump_lock_timer = InputsData.wall_jump_lock_time
			if velocity.y > 0.0:
				# 1. Handle Wall Sliding
				velocity.y = min(velocity.y, InputsData.wall_slide_speed)
		#Gravity fall! Times 2!
		velocity.y += gravity * _delta * 2
		grounded = false

	# 3. Handle Horizontal Movement (with control lock)
	if InputsData.wall_jump_lock_timer <= 0:
		velocity.x = InputsData.move_speed
	else:
		# Air control during wall jump lock (optional, keeps inertia)
		velocity.x = move_toward(velocity.x, 0, 50)

	move_and_slide()

	ghost_frames.append(position)

func _input(_event: InputEvent) -> void:
	pass

func is_any_text_focused(node: Node) -> bool:
	if node is TextEdit or node is LineEdit:
		if node.has_focus():
			return true
	
	for child in node.get_children():
		if is_any_text_focused(child):
			return true
			
	return false

func _unhandled_input(_event: InputEvent) -> void:
	# Checks the entire scene tree for an active text input
	if is_any_text_focused(get_tree().root):
		text_edit_input = true
	else:
		text_edit_input = false

func _player_death() -> void:
	if position.y > 250.0:
		#print("Current Level: ", LevelsDatabase.currLevel + 1)
		if ghost_frames.size() > 0:
			PlayersHelper.record_ghost_run(player_id, run_start_global, ghost_frames)

		position = Vector2(0.0, 0.0)
		owner.global_position = LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position
		InputsData.jump_speed = 0.0
		InputsData.move_speed = 0.0
		is_moving = false
		is_jumping = false

		_start_new_run()
		#print("Player Died!")

func _start_new_run() -> void:
	ghost_frames = PackedVector2Array()
	run_start_global = owner.global_position

func _add_input_actions_for_this_player() -> void:
	# If its the last player - set the actions to be tied to keyboard!
	if player_id == (PlayersHelper.playersCount - 1):
		if not InputMap.has_action(jump_action):
			InputMap.add_action(jump_action)
			var eventAction1 = InputEventKey.new()
			eventAction1.keycode = Key.KEY_SPACE
			InputMap.action_add_event(jump_action, eventAction1)
			var eventAction2 = InputEventKey.new()
			eventAction2.keycode = Key.KEY_UP
			InputMap.action_add_event(jump_action, eventAction2)
		if not InputMap.has_action(move_left_action):
			InputMap.add_action(move_left_action)
			var eventAction1 = InputEventKey.new()
			eventAction1.keycode = Key.KEY_LEFT
			InputMap.action_add_event(move_left_action, eventAction1)
			var eventAction2 = InputEventKey.new()
			eventAction2.keycode = Key.KEY_A
			InputMap.action_add_event(move_left_action, eventAction2)
		if not InputMap.has_action(move_right_action):
			InputMap.add_action(move_right_action)
			var eventAction1 = InputEventKey.new()
			eventAction1.keycode = Key.KEY_RIGHT
			InputMap.action_add_event(move_right_action, eventAction1)
			var eventAction2 = InputEventKey.new()
			eventAction2.keycode = Key.KEY_D
			InputMap.action_add_event(move_right_action, eventAction2)
		if not InputMap.has_action(run_action):
			InputMap.add_action(run_action)
			var eventAction1 = InputEventKey.new()
			eventAction1.keycode = Key.KEY_SHIFT
			InputMap.action_add_event(run_action, eventAction1)
	else:
	# Otherwise, set the actions tied to the joypad accordingly!
		if not InputMap.has_action(jump_action):
			InputMap.add_action(jump_action)
			InputMap.action_set_deadzone(jump_action, 0.2)
			var eventAction1 = InputEventJoypadButton.new()
			eventAction1.button_index = JoyButton.JOY_BUTTON_DPAD_UP
			eventAction1.device = player_id
			InputMap.action_add_event(jump_action, eventAction1)
			var eventAction2 = InputEventJoypadButton.new()
			eventAction2.button_index = JoyButton.JOY_BUTTON_A
			eventAction2.device = player_id
			InputMap.action_add_event(jump_action, eventAction2)
		if not InputMap.has_action(move_left_action):
			InputMap.add_action(move_left_action)
			InputMap.action_set_deadzone(move_left_action, 0.2)
			var eventAction1 = InputEventJoypadButton.new()
			eventAction1.button_index = JoyButton.JOY_BUTTON_DPAD_LEFT
			eventAction1.device = player_id
			InputMap.action_add_event(move_left_action, eventAction1)
			var eventAction2 = InputEventJoypadMotion.new()
			eventAction2.axis = JoyAxis.JOY_AXIS_LEFT_X
			eventAction2.device = player_id
			InputMap.action_add_event(move_left_action, eventAction2)
		if not InputMap.has_action(move_right_action):
			InputMap.add_action(move_right_action)
			InputMap.action_set_deadzone(move_right_action, 0.2)
			var eventAction1 = InputEventJoypadButton.new()
			eventAction1.button_index = JoyButton.JOY_BUTTON_DPAD_RIGHT
			eventAction1.device = player_id
			InputMap.action_add_event(move_right_action, eventAction1)
			var eventAction2 = InputEventJoypadMotion.new()
			eventAction2.axis = JoyAxis.JOY_AXIS_RIGHT_X
			eventAction2.device = player_id
			InputMap.action_add_event(move_right_action, eventAction2)
		if not InputMap.has_action(run_action):
			InputMap.add_action(run_action)
			InputMap.action_set_deadzone(run_action, 0.2)
			var eventAction1 = InputEventJoypadButton.new()
			eventAction1.button_index = JoyButton.JOY_BUTTON_X
			eventAction1.device = player_id
			InputMap.action_add_event(run_action, eventAction1)
			var eventAction2 = InputEventJoypadMotion.new()
			eventAction2.axis = JoyAxis.JOY_AXIS_TRIGGER_RIGHT
			eventAction2.device = player_id
			InputMap.action_add_event(run_action, eventAction2)
