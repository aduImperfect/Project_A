extends SpinBox
class_name LinkedSpinBox

@export var target_autoload: String = "InputsData"
@export var bound_property: String = ""

var _target: Node

func _ready() -> void:
	_target = get_node_or_null("/root/%s" % target_autoload)
	if _target == null:
		push_error("LinkedSpinBox '%s': autoload '%s' not found. Check Project Settings > Autoload." % [name, target_autoload])
		return
	if bound_property.is_empty():
		push_error("LinkedSpinBox '%s': bound_property not set." % name)
		return

	value = _target.get(bound_property)
	_target.value_changed.connect(_on_source_changed)
	value_changed.connect(_on_ui_changed)

func _on_source_changed(property: String, new_value) -> void:
	if property == bound_property and new_value != value:
		value = new_value

func _on_ui_changed(new_value: float) -> void:
	if _target.get(bound_property) != new_value:
		_target.set_value(bound_property, new_value)

func _input(event: InputEvent) -> void:
	if has_focus() and event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.position):
			release_focus()
