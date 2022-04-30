class_name Game

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	return GameState.new()

func on_arrow_fire(state, player, arrow) -> PoolIntArray:
	return PoolIntArray()

func on_target_hit(state, player, arrow, target, points) -> PoolIntArray:
	return PoolIntArray()
	
func ui_action(state, action) -> PoolIntArray:
	return PoolIntArray()
	
# Maybe limit usage? Will be run every frame
func on_update(state, delta) -> PoolIntArray:
	return PoolIntArray()
