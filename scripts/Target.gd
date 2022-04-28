extends Area

var radius: float = 0.65

onready var target_model = get_parent()
onready var center: Spatial = target_model.get_node("Center")

func get_points(x_ray: Vector3, d_ray: Vector3):
	var intersection = get_intersection(x_ray, d_ray)
	var distance_vec = (intersection - center.global_transform.origin)
#	print(distance_vec.length())
	return 100 - 100 * (distance_vec.length() / radius)

func get_intersection(x_ray: Vector3, d_ray: Vector3):
	var x_plane: Vector3 = center.global_transform.origin
	var n_plane: Vector3 = -1 * global_transform.basis.x
#	print("x_ray ", x_ray, "\nd_ray ", d_ray, "\nx_plane ", x_plane, "\nn_plane ", n_plane)
	var x_intersection = x_ray + ((n_plane.dot(x_plane - x_ray))/n_plane.dot(d_ray)) * d_ray
	return x_intersection
