extends Spatial

var state: int
var velocity_range = [0, 1]
var arrow_z_range = [-.2, 0.33]
var forward_vel: float = 0
var gravity_vel: Vector3 = Vector3.ZERO
var wind_vel: Vector3 = Vector3.ZERO
var score = 0
var timer = 10

var player: Spatial
onready var model: Spatial = get_node("Model")
onready var arrowhead: MeshInstance = get_node("Model/ArrowHead")
onready var gameManager: GameManager = get_node("/root/Spatial/GameManager")

var prev_pos: Vector3 = Vector3(0, 0, 0)
var landedTime: int = 0

func _physics_process(delta):
	if state != Enums.ArrowState.NOCKED:
		timer -= delta
	if timer < 0 or (landedTime != 0 and landedTime < gameManager.currentGameState.targets_placed_time):
		call_deferred("queue_free")
	if state == Enums.ArrowState.IN_FLIGHT:
		prev_pos = global_transform.origin
		gravity_vel += gameManager.currentGameState.gravity * delta
		wind_vel += gameManager.currentGameState.wind * delta
		translate(Vector3(0, 0, forward_vel))
		global_translate(gravity_vel)
		global_translate(wind_vel)
		var look_dir = global_transform.origin - prev_pos
		model.look_at(global_transform.origin - look_dir,  Vector3.UP)

func adjust_draw(draw: float):
	if state == Enums.ArrowState.NOCKED:
		translation = Vector3(translation.x, translation.y, Util.in_range(arrow_z_range, draw))

func fire(draw: float) -> bool:
	if state == Enums.ArrowState.NOCKED:
		forward_vel = -1 * Util.in_range(velocity_range, draw)
		state = Enums.ArrowState.IN_FLIGHT
		gameManager.on_arrow_fire(player, self)
		return true
	return false

func _on_Area_area_entered(area):
	state = Enums.ArrowState.LANDED
	landedTime = OS.get_unix_time()
	score = area.get_points(arrowhead.global_transform.origin, -1 * global_transform.basis.z)
	gameManager.on_target_hit(player, self, area, score)


