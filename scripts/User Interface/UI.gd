extends Control

onready var optionsMenu: PopupMenu = get_node("GameMenu")
onready var scoreLabel: Label = get_node("Score")

# TODO quiver menu, score connection w0ith GameManager

func _on_OptionsButton_pressed():
	optionsMenu.popup_centered_ratio()

func update_score(score_texts: PoolStringArray, color: Color):
	var text = ""
	for string in score_texts:
		text += string
		text += "\n"
	scoreLabel.text = text
	scoreLabel.font_color = color
	
