# res://Scripts/linked_text_edit.gd
extends TextEdit
class_name LinkedTextEdit

@export var target_autoload: String = "InputsData"
@export var bound_property: String = ""
@export var value_prefix: String = "" # e.g. "Jump Speed Dec: "

var _target: Node
var _value_regex: RegEx

func _ready() -> void:
	_target = get_node_or_null("/root/%s" % target_autoload)
	if _target == null:
		push_error("LinkedTextEdit '%s': autoload '%s' not found." % [name, target_autoload])
		return
	if bound_property.is_empty():
		push_error("LinkedTextEdit '%s': bound_property not set." % name)
		return

	_value_regex = RegEx.new()
	_value_regex.compile("-?\\d+\\.?\\d*")

	text = value_prefix + str(_target.get(bound_property))
	_target.value_changed.connect(_on_source_changed)
	text_changed.connect(_on_text_changed)

func _on_source_changed(property: String, new_value) -> void:
	if property == bound_property:
		text = value_prefix + str(new_value)

func _on_text_changed() -> void:
	if InputsData.begin_delay:
		return
	var result := _value_regex.search(text)
	if result:
		var new_value := result.get_string().to_float()
		if _target.get(bound_property) != new_value:
			_target.set_value(bound_property, new_value)

func _input(event: InputEvent) -> void:
	if has_focus() and event is InputEventMouseButton and event.pressed:
		if not get_global_rect().has_point(event.position):
			release_focus()
