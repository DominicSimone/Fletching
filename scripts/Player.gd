extends Spatial

var max_draw: float = 1
var bow_draw: float = 0

var arrow_z = [-.2, 0.33]
var arrowScene = preload("res://scenes/Arrow.tscn")
var nockedArrow: Spatial
var shot_arrows = []

export(NodePath) var camera_path
onready var camera: Camera = get_node(camera_path)
var fov_range = [60, 40]

var rot_x: float = 0
var rot_y: float = 0

func _ready():
	new_arrow()

func new_arrow():
	nockedArrow = arrowScene.instance()
	add_child(nockedArrow)
	bow_draw = 0

func _input(event):
	# Use screen drag to pull back arrow + adjust FOV
	if event is InputEventScreenDrag and nockedArrow != null:
		bow_draw += event.relative.y / OS.window_size.y
		bow_draw = clamp(bow_draw, 0, max_draw)
		camera.fov = Util.in_range(fov_range, bow_draw)
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
				camera.fov = Util.in_range(fov_range, bow_draw)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# While developing, use WASD to rotate player
	if Input.is_action_pressed("left"):
		rot_x += delta
	if Input.is_action_pressed("right"):
		rot_x -= delta
	if Input.is_action_pressed("up"):
		rot_y += delta
	if Input.is_action_pressed("down"):
		rot_y -= delta
	
	transform.basis = Basis()
	rotate_object_local(Vector3.UP, rot_x)
	rotate_object_local(Vector3.RIGHT, rot_y)
	
	# TODO Use gyroscope to rotate player


