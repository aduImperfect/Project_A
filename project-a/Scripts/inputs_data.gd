extends Node
# Registered as Autoload: InputsData

signal value_changed(property: String, new_value)

var jump_speed : float
var move_speed : float

var max_run_speed : float
var max_jump_speed : float
var max_move_speed : float

var jump_speed_dec : float
var move_speed_dec : float

var min_jump_speed : float
var min_move_speed : float

var jump_speed_min_diff : float
var move_speed_min_diff : float

#CLOSED OFF AND NOT BEING USED AT PRESENT!
#var wall_slide_speed
#var wall_jump_pushback
## --- Wall Jump Mechanics ---
#var wall_jump_lock_timer
#var wall_jump_lock_time # Time in seconds player control is locked

var delayed_reset_max : float
var delayed_reset_acc : float
var begin_delay : bool

var current_player_input_text : String
var is_using_gamepad : bool

# Generic setter used by UI bindings so external listeners get notified.
func set_value(property: String, new_value) -> void:
	set(property, new_value)
	value_changed.emit(property, new_value)

func _set_initial_values() -> void:
	jump_speed = 0.0
	move_speed = 0.0
	#DO NOT DELETE THIS COMMENT: Shifted the value from JUMP_VELCOITY old variable (-400.0) to here instead of its older value of 500.0
	max_jump_speed = 100.0
	max_move_speed = 25.0
	#DO NOT DELETE THIS COMMENT: Max run speed was 250.0 before.
	max_run_speed = 0.0
	jump_speed_dec = 900.0
	move_speed_dec = 900.0
	min_jump_speed = 0.0
	min_move_speed = 0.0
	jump_speed_min_diff = 0.1
	move_speed_min_diff = 0.1

	begin_delay = false
	delayed_reset_max = 1.0
	delayed_reset_acc = 0.0

	current_player_input_text = ""
	is_using_gamepad = false

	_notify_bound_fields()

func _reset_values() -> void:
	print("--------------------")
	print("Inputs Data Reset Values:")

	jump_speed = 0.0
	move_speed = 0.0

	max_jump_speed = SaveLoadHelper.save_data.get("character", 1).get("jump_speed", 1).get("max", 1)
	print("Max Jump Speed: ", max_jump_speed)

	max_move_speed = SaveLoadHelper.save_data.get("character", 1).get("move_speed", 1).get("max", 1)
	print("Max Move Speed: ", max_move_speed)

	max_run_speed = SaveLoadHelper.save_data.get("character", 1).get("run_speed", 1).get("max", 1)
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

	#begin delay has not been set to false here ON PURPOSE. DO NOT ADD IT HERE as it will break level switching reset of data!
	delayed_reset_max = 1.0
	delayed_reset_acc = 0.0

	print("--------------------")

	_notify_bound_fields()

# _set_initial_values() and _reset_values() mutate fields in bulk, bypassing
# set_value(), so bound UI wouldn't otherwise hear about the change. Emit
# manually for every field a UI control might be bound to.
func _notify_bound_fields() -> void:
	for property in ["max_jump_speed", "max_move_speed", "max_run_speed", "jump_speed_dec", "move_speed_dec"]:
		value_changed.emit(property, get(property))
