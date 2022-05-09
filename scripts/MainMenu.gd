extends Control

onready var gameManager = get_node("/root/Spatial/GameManager")
onready var primaryControl: Control = get_node("Primary")
onready var secondaryPlayControl: Control = get_node("SecondaryPlay")

func _on_Play_pressed():
	primaryControl.visible = false
	secondaryPlayControl.visible = true

func _on_Scores_pressed():
	# TODO
	print("Scores screen")

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
