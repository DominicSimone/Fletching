class_name GameManager extends Node

var currentGameState: GameState 
var currentGame: Game
var UI: Control
var playerData: PlayerData

func _ready():
	# TODO Load player data
	pass

func load_game(game: Game):
	currentGame = game
	currentGameState = game.init_state()
	UI = get_node("/root/Spatial/Game/UI")

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
				UI.update_score(currentGameState.displayed_scores)
			Enums.GameResponse.END_GAME:
				# TODO store these results somewhere
				# TODO show end game screen
				var results = currentGame.score_summary(currentGameState)

func _process(delta):
	if currentGame != null:
		handleResponse(currentGame.on_update(currentGameState, delta))
