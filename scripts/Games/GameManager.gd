class_name GameManager extends Node

var currentGameState: GameState 
var currentGame: Game
var UI: UI
var playerData: PlayerData
var targetNode: Spatial

func _ready():
	# TODO Load player data
	pass

func load_game(game: Game):
	currentGame = game
	currentGameState = game.init_state()
	targetNode = get_node("/root/Spatial/Targets")
	UI = get_node("/root/Spatial/Game/UI")
	UI.load_game_options(currentGame.get_action_list(), self, "ui_action")

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
				place_targets()
			Enums.GameResponse.UPDATE_SCORE:
				UI.update_score(currentGameState.displayed_scores)
			Enums.GameResponse.END_GAME:
				# TODO store these results somewhere
				var results: Dictionary = {
					"score": Util.sum_scores(currentGameState.scores),
					"coin_gain": currentGameState.coin_gain
				}
				UI.show_results(results)

func _process(delta):
	if currentGame != null:
		handleResponse(currentGame.on_update(currentGameState, delta))

func place_targets():
	# TODO
	if currentGameState.target_locations.size() > targetNode.get_child_count():
		pass
	pass
