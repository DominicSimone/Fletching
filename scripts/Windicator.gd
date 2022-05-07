extends Spatial

onready var gameManager: GameManager = get_node("/root/Spatial/GameManager")

func _process(delta):
	var wind = gameManager.currentGameState.wind
	if wind == null or wind == Vector3.ZERO:
		visible = false
	else:
		visible = true
		look_at(global_transform.origin + wind, Vector3.UP)
		scale.z = wind.length() / 0.5
