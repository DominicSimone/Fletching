class_name TimeAttack extends Game

var time_limit = 30

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	var state = GameState.new()
	state.gamemode = Enums.GameMode.TIME_ATTACK
	state.wind = randomWind()
	state.status = Enums.GameStatus.READY
	state.target_locations = [randomLoc()]
	state.metadata.timer = time_limit
	state.metadata.total_score = 0
	state.displayed_scores = [state.metadata.timer as String]
	return state

func on_arrow_fire(state: GameState, player, arrow) -> PoolIntArray:
	state.status = Enums.GameStatus.ONGOING
	return PoolIntArray()

func on_target_hit(state: GameState, player, arrow, target, points) -> PoolIntArray:
	# Track score and display
	var score = Score.new(points, player.global_transform.origin.distance_to(target.global_transform.origin), state.wind)
	state.scores.append(score)
	state.metadata.total_score += score.getValue()
	state.displayed_scores = [state.metadata.timer, ceil(state.metadata.total_score) as String, "+%d" % ceil(score.getValue())]
	state.coin_gain = 1
	
	# Move targets and wind
	state.target_locations[0] = randomLoc()
	state.wind = randomWind()
	
	# Add additional time
	state.metadata.timer += 1
	return PoolIntArray([Enums.GameResponse.UPDATE_SCORE, Enums.GameResponse.PLACE_TARGETS])
	
func get_action_list() -> Array:
	return ["End Game"]

func ui_action(state: GameState, action) -> PoolIntArray:
	match action:
		"End Game":
			state.status = Enums.GameStatus.COMPLETE
			return PoolIntArray([Enums.GameResponse.END_GAME])
	return PoolIntArray()
	
func on_update(state: GameState, delta) -> PoolIntArray:
	if state.metadata.timer <= 0 and state.status != Enums.GameStatus.COMPLETE:
		state.status = Enums.GameStatus.COMPLETE
		return PoolIntArray([Enums.GameResponse.END_GAME])
	if state.status == Enums.GameStatus.ONGOING:
		state.metadata.timer -= delta
		state.displayed_scores[0] = "%d" % state.metadata.timer
		return PoolIntArray([Enums.GameResponse.UPDATE_SCORE])
	return PoolIntArray()

func randomWind() -> Vector3:
	return Vector3(rand_range(-0.5, 0.5), 0, rand_range(-0.5, 0.5))

func randomLoc() -> Vector3:
	return Vector3(rand_range(-12, 12), 0, rand_range(-12, 12))
