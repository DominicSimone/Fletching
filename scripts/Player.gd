extends Spatial

var max_draw: float = 1
var bow_draw: float = 0

var arrow_z = [-.2, 0.33]
var arrowScene = preload("res://scenes/Arrow.tscn")
var nockedArrow: Spatial
var shot_arrows = []

export(NodePath) var camera_path
onready var camera: Camera = get_node(camera_path)
var fov_range = [40, 60]
var sense_range = [0.2, 1]

var prev_gyro: Vector3 = Vector3.ZERO

var rot_x: float = 0
var rot_y: float = 0

func _ready():
	new_arrow()

func new_arrow():
	nockedArrow = arrowScene.instance()
	add_child(nockedArrow)
	bow_draw = 0
	nockedArrow.adjust_draw(bow_draw)

func _input(event):
	# Use screen drag to pull back arrow + adjust FOV
	if event is InputEventScreenDrag and nockedArrow != null:
		bow_draw += event.relative.y / (OS.window_size.y * 0.8)
		bow_draw = clamp(bow_draw, 0, max_draw)
		camera.fov = Util.in_range(fov_range, 1 - bow_draw, true)
		nockedArrow.adjust_draw(bow_draw)
		
	if event is InputEventScreenTouch:
		if not event.pressed and nockedArrow == null:
			new_arrow()
		if not event.pressed and bow_draw > 0:
			if nockedArrow.fire(bow_draw):
				Util.move(nockedArrow, self, get_parent())
				shot_arrows.append(nockedArrow)
				nockedArrow = null
				bow_draw = 0
				camera.fov = Util.in_range(fov_range, 1 - bow_draw)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# While developing, use WASD to rotate player
	if Input.is_action_pressed("left"):
		rot_x += delta * Util.in_range(sense_range, 1 - bow_draw)
	if Input.is_action_pressed("right"):
		rot_x -= delta * Util.in_range(sense_range, 1 - bow_draw)
	if Input.is_action_pressed("up"):
		rot_y += delta * Util.in_range(sense_range, 1 - bow_draw)
	if Input.is_action_pressed("down"):
		rot_y -= delta * Util.in_range(sense_range, 1 - bow_draw)
	
	var gyro: Vector3 = Input.get_gyroscope()
	rot_x += (gyro.x - prev_gyro.x) * delta * Util.in_range(sense_range, 1 - bow_draw)
	rot_y += (gyro.y - prev_gyro.y) * delta * Util.in_range(sense_range, 1 - bow_draw)
	prev_gyro = gyro
	
	transform.basis = Basis()
	rotate_object_local(Vector3.UP, rot_x)
	rotate_object_local(Vector3.RIGHT, rot_y)
	


