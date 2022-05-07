class_name UI extends Control

onready var optionsMenu: Control = get_node("OptionsMenu")
onready var quiverMenu: Control = get_node("QuiverMenu")
onready var scoreLabel: Label = get_node("Score")
onready var vbox: VBoxContainer = get_node("OptionsMenu/Background/ScrollContainer/VBoxContainer")
onready var hbox: HBoxContainer = get_node("QuiverMenu/HBoxContainer")

onready var arrowButtonRes = preload("res://scenes/ArrowIconButton.tscn")

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		optionsMenu.visible = false

func _on_OptionsButton_pressed():
	optionsMenu.visible = !optionsMenu.visible

func _on_QuiverButton_pressed():
	quiverMenu.visible = !quiverMenu.visible

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

func load_quiver_options(quiver: Dictionary, executor: Object, method: String):
	for arrow_type in quiver:
		var icon: ArrowIconButton = arrowButtonRes.instance()
		hbox.add_child(icon)
		icon.arrowType = arrow_type
		icon.numArrows = quiver[arrow_type]
		icon.texButton.connect("pressed", executor, method, [arrow_type])

func load_game_options(action_list: Array, executor: Object, method: String):
	for menu_option in action_list:
		var control = Control.new()
		var button = Button.new()
		button.text = menu_option
		button.connect("pressed", executor, method, [menu_option])
		control.add_child(button)
		vbox.add_child(control)
