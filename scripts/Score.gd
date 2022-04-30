class_name Score

var points
var distance
var wind: Vector3
var value: int

var arrowType: int = Enums.ArrowType.DEFAULT

func _init(p, dist, w: Vector3):
	points = p
	distance = dist
	wind = w

# TODO factor in distance and wind to give a score more related to the difficulty of the shot
func getValue() -> int:
	return points
	
