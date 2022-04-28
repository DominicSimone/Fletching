class_name Game

# Initialize game state here; set initial wind direction, quiver, timer value, etc.
func init_state() -> GameState:
	return GameState.new()

func on_arrow_fire():
	pass

func on_target_hit():
	pass

func on_timer_expire():
	pass

# Maybe limit usage? Will be run every frame
func on_update():
	pass
