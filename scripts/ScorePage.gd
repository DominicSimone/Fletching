extends Control

onready var freePlayContainer: VBoxContainer = get_node("ScrollContainer/VBoxContainer/FreePlayContainer")
onready var timeAttackContainer: VBoxContainer = get_node("ScrollContainer/VBoxContainer/TimeAttackContainer")
onready var standardContainer: VBoxContainer = get_node("ScrollContainer/VBoxContainer/StandardContainer")

func populate(playerData: PlayerData):
	var mapping = {
		Enums.GameMode.FREE_PLAY: freePlayContainer,
		Enums.GameMode.TIME_ATTACK: timeAttackContainer,
		Enums.GameMode.STANDARD: standardContainer
	}
	for gameMode in playerData.scores:
		var scores = playerData.scores[gameMode]
		var container: VBoxContainer = mapping[gameMode]
		for label in container.get_children():
			label.queue_free()
		for scoreSet in scores:
			var score_label = Label.new()
			score_label.text = "   %d" % ceil(Util.sum_scores(scoreSet))
			container.add_child(score_label)
