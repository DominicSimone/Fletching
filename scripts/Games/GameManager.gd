class_name GameManager extends Node

var currentGameState: GameState 
var currentGame: Game
onready var UI: Control = get_node("/root/Spatial/UI")

func _ready():
	load_game(FreePlay.new())
	print("FreePlay loaded")

func load_game(game: Game):
	currentGame = game
	currentGameState = game.init_state()

func get_action_list():
	if currentGame.action_list == null:
		return []
	return currentGame.action_list

func on_arrow_fire(player, arrow):
	handleResponse(currentGame.on_arrow_fire(currentGameState, player, arrow))

func on_target_hit(player, arrow, target, points):
	handleResponse(currentGame.on_target_hit(currentGameState, player, arrow, target, points))
	
func ui_action(action):
	handleResponse(currentGame.ui_action(currentGameState, action))

func handleResponse(responses: PoolIntArray):
	for response in responses:
		match response:
			Enums.GameResponse.PLACE_TARGETS:
				pass
			Enums.GameResponse.UPDATE_SCORE:
				pass

func _process(delta):
	pass
