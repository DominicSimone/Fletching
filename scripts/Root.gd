extends Spatial

var gameScene = preload("res://scenes/Game.tscn")
var mainMenuScene = preload("res://scenes/Main Menu.tscn")

func _ready():
	randomize()

func return_to_menu():
	get_node("Game").queue_free()
	add_main_menu_node()

func add_game_node():
	var gameNode = gameScene.instance()
	add_child(gameNode)

func add_main_menu_node():
	var mm = mainMenuScene.instance()
	add_child(mm)
