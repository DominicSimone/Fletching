class_name FreePlay extends Game

var action_list = [
	"Move Target",
	"Toggle Wind",
	"End Game"
]

var name = "Free Play"

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	var state = GameState.new()
	state.gamemode = Enums.GameMode.FREE_PLAY
	state.metadata.wind_toggle = true
	state.wind = randomWind()
	state.status = Enums.GameStatus.READY
	state.target_locations = [randomLoc()]
	return state

func on_arrow_fire(state: GameState, player, arrow) -> PoolIntArray:
	state.status = Enums.GameStatus.ONGOING
	return PoolIntArray()

func on_target_hit(state: GameState, player, arrow, target, points) -> PoolIntArray:
	var score = Score.new(points, player.global_transform.origin.distance_to(target.global_transform.origin), state.wind)
	if state.scores.empty():
		state.scores.append(score)
	elif state.scores[0].getValue() < score.getValue():
		state.scores[0] = score
	state.displayed_scores = [ceil(score.getValue()) as String]
	state.coin_gain = 1
	return PoolIntArray([Enums.GameResponse.UPDATE_SCORE])

func ui_action(state: GameState, action) -> PoolIntArray:
	match action:
		"Move Target":
			state.target_locations[0] = randomLoc()
			return PoolIntArray([Enums.GameResponse.PLACE_TARGETS])
		"Toggle Wind":
			state.metadata.wind_toggle = !state.metadata.wind_toggle
			if state.metadata.wind_toggle:
				state.wind = randomWind()
			else:
				state.wind = Vector3.ZERO
		"End Game":
			return PoolIntArray([Enums.GameResponse.END_GAME])
	return PoolIntArray()

func on_update(state: GameState, delta) -> PoolIntArray:
	return PoolIntArray()

func get_action_list() -> Array:
	return action_list

func randomWind() -> Vector3:
	var rand_x = randf() - 0.5
	var rand_z = randf() - 0.5
	return Vector3(rand_x, 0, rand_z)

func randomLoc() -> Vector3:
	var rand_x = (randf() * 24) - 12
	var rand_z = (randf() * 24) - 12 
	return Vector3(rand_x, 0, rand_z)
