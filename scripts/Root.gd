extends Spatial

var gameScene = preload("res://scenes/Game.tscn")

func _ready():
	randomize()

func add_game_node():
	var gameNode = gameScene.instance()
	add_child(gameNode)
