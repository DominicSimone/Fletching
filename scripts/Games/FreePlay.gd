class_name FreePlay extends Game

var action_list = [
	"Move Target",
	"Toggle Wind"
]

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	var state = GameState.new()
	state.gamemode = Enums.GameMode.FREE_PLAY
	state.metadata.wind_toggle = true
	state.status = Enums.GameStatus.READY
	state.target_locations = [Vector3.ZERO]
	return state

func on_arrow_fire(state, player, arrow) -> PoolIntArray:
	return PoolIntArray()

func on_target_hit(state, player, arrow, target, points) -> PoolIntArray:
	return PoolIntArray()

func ui_action(state, action) -> PoolIntArray:
	match action:
		"Move Target":
			return PoolIntArray()
		"Toggle Wind":
			return PoolIntArray()
	return PoolIntArray()

# Maybe limit usage? Will be run every frame
func on_update(state, delta) -> PoolIntArray:
	return PoolIntArray()
