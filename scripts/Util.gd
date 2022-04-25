class_name Util

static func in_range(r: Array, v: float) -> float:
	return ((r[1] - r[0]) * v) + r[0] 

static func move(target: Spatial, from: Spatial, to: Spatial):
	var current_global_transform = target.global_transform
	from.remove_child(target)
	to.add_child(target)
	target.global_transform = current_global_transform
