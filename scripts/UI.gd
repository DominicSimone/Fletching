class_name UI extends Control

onready var optionsMenu: Control = get_node("OptionsMenu")
onready var scoreLabel: Label = get_node("Score")
onready var vbox: VBoxContainer = get_node("OptionsMenu/Background/ScrollContainer/VBoxContainer")
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

func show_results(results: Dictionary):
	# TODO
	pass

func load_game_options(action_list: Array, executor: Object, method: String):
	for menu_option in action_list:
		var control = Control.new()
		var button = Button.new()
		button.text = menu_option
		button.connect("pressed", executor, method, [menu_option])
		control.add_child(button)
		vbox.add_child(control)
