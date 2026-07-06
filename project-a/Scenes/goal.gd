extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func _on_body_entered(body: Node2D) -> void:
	if LevelsDatabase.currLevel == LevelsDatabase.numLevels:
		return

	if body.name.contains("Player"):
		print("Goal at: " + owner.owner.name + " reached!")
		LevelsDatabase.currLevel += 1

		if LevelsDatabase.currLevel == LevelsDatabase.numLevels:
			print("Game Complete")
			return

		print(LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position)
		body.position = Vector2(0.0, 0.0)
		body.owner.global_position = LevelsDatabase.levelNodes[LevelsDatabase.currLevel].get_child(0).global_position
