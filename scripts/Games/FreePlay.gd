class_name FreePlay extends Game

var action_list = [
	"Move Target",
	"Toggle Wind",
	"End Game"
]

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	var state = GameState.new()
	state.gamemode = Enums.GameMode.FREE_PLAY
	state.metadata.wind_toggle = true
	state.status = Enums.GameStatus.READY
	state.target_locations = [Vector3.ZERO]
	return state

func on_arrow_fire(state: GameState, player, arrow) -> PoolIntArray:
	state.status = Enums.GameStatus.ONGOING
	return PoolIntArray()

func on_target_hit(state: GameState, player, arrow, target, points) -> PoolIntArray:
	state.displayed_scores = [ceil(points) as String]
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

# Maybe limit usage? Will be run every frame
func on_update(state: GameState, delta) -> PoolIntArray:
	return PoolIntArray()

func end_summary(state: GameState) -> Dictionary:
	# TODO return the highest score achieved
	return {}

# TODO
func randomWind() -> Vector3:
	return Vector3.ZERO

# TODO 
func randomLoc() -> Vector3:
	return Vector3.ZERO
