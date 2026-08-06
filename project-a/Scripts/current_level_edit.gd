# res://Scripts/current_level_edit.gd
extends LinkedSpinBox

func _ready() -> void:
	target_autoload = "LevelsDatabase"
	bound_property = "currLevel"
	super._ready()

func _on_source_changed(property: String, new_value) -> void:
	if property == bound_property:
		value = new_value + 1

func _on_ui_changed(new_value: float) -> void:
	var first_int := int(new_value)
	if first_int > 0 and (first_int - 1) != LevelsDatabase.currLevel:
		LevelsDatabase._level_switcher(first_int - 1)
