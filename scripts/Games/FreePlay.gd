class_name FreePlay extends Game

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

func get_action_list() -> Array:
	return [
		"Move Target",
		"Toggle Wind",
		"End Game"
	]

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
			state.status = Enums.GameStatus.COMPLETE
			return PoolIntArray([Enums.GameResponse.END_GAME])
	return PoolIntArray()

func on_update(state: GameState, delta) -> PoolIntArray:
	return PoolIntArray()

func randomWind() -> Vector3:
	return Vector3(rand_range(-0.5, 0.5), 0, rand_range(-0.5, 0.5))

func randomLoc() -> Vector3:
	return Vector3(rand_range(-12, 12), 0, rand_range(-12, 12))
