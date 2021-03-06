class_name GameManager extends Node

var targetScene = preload("res://scenes/Target.tscn")

var currentGameState: GameState = GameState.new()
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
	place_targets()
	UI = get_node("/root/Spatial/Game/UI")
	UI.load_game_options(currentGame.get_action_list(), self, "ui_action")
	UI.load_quiver_options(playerData.quiver, self, "select_arrow")
	UI.update_score(currentGameState.displayed_scores)

func on_game_end(action):
	match action:
		"to_menu":
			get_parent().return_to_menu()
		"restart":
			currentGameState = currentGame.init_state()
			place_targets()
			UI.close_menus()
			UI.update_score(currentGameState.displayed_scores)

func select_arrow(arrow_type):
	if playerData.quiver[arrow_type] > 0:
		playerNode.select_arrow(arrow_type)

func on_arrow_fire(player, arrow):
	playerData.quiver[arrow.arrowType] -= 1
	UI.update_quiver_options(playerData.quiver)
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
				var results: Dictionary = {
					"score": ceil(Util.sum_scores(currentGameState.scores)),
					"coin_gain": currentGameState.coin_gain
				}
				if results.score > 0:
					playerData.coins += currentGameState.coin_gain
					playerData.add_score(currentGameState.scores, currentGameState.gamemode)
				var jsonData = playerData.serialize()
				Util.saveJSON(jsonData, "data.json")
				UI.show_results(results, self, "on_game_end")

func _process(delta):
	if currentGame != null:
		handleResponse(currentGame.on_update(currentGameState, delta))

func place_targets():
	var removeCount = targetNode.get_child_count() - currentGameState.target_locations.size()
	for i in range(abs(removeCount)):
		if removeCount > 0:
			var deadTarget = targetNode.get_child(i)
			targetNode.remove_child(deadTarget)
			deadTarget.call_deferred("queue_free")
		if removeCount < 0:
			var newTarget = targetScene.instance()
			targetNode.add_child(newTarget)
	for index in range(currentGameState.target_locations.size()):
		var target = targetNode.get_child(index)
		target.global_transform.origin = currentGameState.target_locations[index]
		target.look_at(playerNode.global_transform.origin, Vector3.UP)
		
