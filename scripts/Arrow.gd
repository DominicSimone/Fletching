extends Spatial

var state: int
var velocity_range = [0, 1]
var arrow_z_range = [-.2, 0.33]
var forward_velocity: float = 0
var gravity: float = 0

onready var model: Spatial = get_node("Model")
onready var arrowhead: MeshInstance = get_node("Model/ArrowHead")

var prev_pos: Vector3 = Vector3(0, 0, 0)

func _physics_process(delta):
	if state == Enums.ArrowState.IN_FLIGHT:
		prev_pos = global_transform.origin
		gravity += delta * .15
		translate(Vector3(0, 0, forward_velocity))
		global_translate(Vector3(0, -1 * gravity, 0))
		var look_dir = global_transform.origin - prev_pos
		model.look_at(global_transform.origin - look_dir,  Vector3.UP)

func adjust_draw(draw: float):
	if state == Enums.ArrowState.NOCKED:
		translation = Vector3(translation.x, translation.y, Util.in_range(arrow_z_range, draw))

func fire(draw: float) -> bool:
	if state == Enums.ArrowState.NOCKED:
		print("arrow fired")
		forward_velocity = -1 * Util.in_range(velocity_range, draw)
		state = Enums.ArrowState.IN_FLIGHT
		return true
	return false

# TODO score evaluation + move arrow to surface of target? to keep physics fps low?
func _on_Area_area_entered(area):
	state = Enums.ArrowState.LANDED
	area.get_depth(arrowhead.global_transform.origin, to_global(Vector3.FORWARD))
	print(area.get_points(arrowhead.global_transform.origin))
	print("Collided with something")
