extends Area

var radius: float = 0.6

onready var target_model = get_parent()
onready var center: Spatial = target_model.get_node("Center")

func get_points(global_position: Vector3):
	var local_point = to_local(global_position)
	var distance_vec = (local_point - center.transform.origin)
	# Target is flush with y/z plane
	distance_vec.x = 0
	return 100 - 100 * (distance_vec.length() / radius)

func get_depth(global_position: Vector3, global_look_dir: Vector3):
	pass
