class_name GameManager extends Node

var targetScene = preload("res://scenes/Target.tscn")

var currentGameState: GameState 
var currentGame: Game
var UI: UI
var playerData: PlayerData = PlayerData.new()
var targetNode: Spatial
var playerNode: Spatial

func _ready():
	var playerDataJson = Util.loadJSON("data.json")
	if playerDataJson != null:
		playerData.deserialize(playerDataJson)

func load_game(game: Game):
	currentGame = game
	currentGameState = game.init_state()
	targetNode = get_node("/root/Spatial/Game/Targets")
	playerNode = get_node("/root/Spatial/Game/Player")
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
				currentGameState.targets_placed_time = OS.get_unix_time()
			Enums.GameResponse.UPDATE_SCORE:
				UI.update_score(currentGameState.displayed_scores)
			Enums.GameResponse.END_GAME:
				# TODO incorporate results into player data and save it
				var results: Dictionary = {
					"score": Util.sum_scores(currentGameState.scores),
					"coin_gain": currentGameState.coin_gain
				}
				playerData.coins += currentGameState.coin_gain
				UI.show_results(results)

func _process(delta):
	if currentGame != null:
		handleResponse(currentGame.on_update(currentGameState, delta))

func place_targets():
	var removeCount = targetNode.get_child_count() - currentGameState.target_locations.size()
	for i in range(abs(removeCount)):
		if removeCount > 0:
			var deadTarget = targetNode.get_child(0)
			targetNode.remove_child(deadTarget)
			deadTarget.call_deferred("queue_free")
		if removeCount < 0:
			var newTarget = targetScene.instance()
			targetNode.add_child(newTarget)
	for index in range(currentGameState.target_locations.size()):
		var target = targetNode.get_child(index)
		target.global_transform.origin = currentGameState.target_locations[index]
		target.look_at(playerNode.global_transform.origin, Vector3.UP)
		
