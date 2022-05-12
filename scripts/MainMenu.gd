extends Control

onready var gameManager: GameManager = get_node("/root/Spatial/GameManager")
onready var primaryControl: Control = get_node("PrimaryPlay")
onready var secondaryPlayControl: Control = get_node("SecondaryPlay")
onready var scorePageControl: Control = get_node("Scores")
onready var shopControl: Control = get_node("Shop")

func _input(event):
	if event.is_action_pressed("ui_cancel"):
		hideAll()
		primaryControl.visible = true

func _notification(what):
	if what == MainLoop.NOTIFICATION_WM_QUIT_REQUEST:
		hideAll()
		primaryControl.visible = true

func hideAll():
	primaryControl.visible = false
	secondaryPlayControl.visible = false
	scorePageControl.visible = false
	shopControl.visible = false
	
func _on_Play_pressed():
	hideAll()
	secondaryPlayControl.visible = true

func _on_Scores_pressed():
	hideAll()
	scorePageControl.populate(gameManager.playerData)
	scorePageControl.visible = true

func _on_Shop_pressed():
	# TODO
	print("Shop")

func _on_Free_Play_pressed():
	get_parent().add_game_node()
	gameManager.load_game(FreePlay.new())
	call_deferred("queue_free")

func _on_Time_Attack_pressed():
	get_parent().add_game_node()
	gameManager.load_game(TimeAttack.new())
	call_deferred("queue_free")

func _on_Standard_pressed():
	# TODO when standard game mode is made
	pass 
