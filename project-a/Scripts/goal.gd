extends Area2D

@export var playersEnteredGoal : Array[bool] = []

@export var initial_setup : bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	if initial_setup == false:
		for k in PlayersHelper.playerNodes.size():
			playersEnteredGoal.append(false)
		initial_setup = true

func _on_body_entered(body: Node2D) -> void:
	if LevelsDatabase.currLevel >= LevelsDatabase.levelsCount:
		return

	for k in PlayersHelper.playerNodes.size():
		if body.owner.name == PlayersHelper.playerNodes[k].name:
			#print("Goal at: " + owner.owner.name + " reached by Player: " + body.owner.name)
			playersEnteredGoal[k] = true
			break

	var allPlayersEntered : bool = (playersEnteredGoal.size() > 0)
	for k in playersEnteredGoal.size():
		if playersEnteredGoal[k] == false:
			allPlayersEntered = false
			break

	#Only progress to next level if all players reached!
	if allPlayersEntered:
		LevelsDatabase._level_switcher()
