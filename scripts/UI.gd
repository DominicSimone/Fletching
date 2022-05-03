extends Control

onready var optionsMenu: Control = get_node("OptionsMenu")
onready var scoreLabel: Label = get_node("Score")

# TODO quiver menu

func _on_OptionsButton_pressed():
	optionsMenu.visible = !optionsMenu.visible

func update_score(score_texts: PoolStringArray, color: Color = Color.black):
	var text = ""
	for string in score_texts:
		text += string
		text += "\n"
	scoreLabel.text = text
	scoreLabel.add_color_override("font_color", color)
