#class_name LinkedSpinBox
#extends SpinBox
#
### Name of the autoload singleton to read/write, e.g. "InputsData"
#@export var target_autoload: String = "InputsData"
### Property on that autoload to bind to, e.g. "max_move_speed"
#@export var target_property: String = ""
#
#var _target: Object
#var _timer_accum: float = 0.0
#var _timer_max: float = 0.5
#var _synced: bool = false
#
#func _ready() -> void:
	#_target = get_node("/root/%s" % target_autoload)
	#_timer_accum = 0.0
	#_synced = false
#
#func _process(delta: float) -> void:
	#if not _synced:
		#_timer_accum += delta
		#if _timer_accum > _timer_max:
			#_timer_accum = 0.0
			#value = _target.get(target_property)
			#_synced = true
		#return
#
	#if InputsData.begin_delay:
		#_synced = false
	#else:
		#_write_back(value)
#
#func _write_back(new_value) -> void:
	#_target.set(target_property, new_value)
#
#func _input(event: InputEvent) -> void:
	#if has_focus() and event is InputEventMouseButton and event.pressed:
		#if not get_global_rect().has_point(event.position):
			#release_focus()
