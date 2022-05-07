class_name ArrowIconButton extends Control

onready var label = get_node("Label")
onready var texButton: TextureButton = get_node("TextureButton")
var texMapping = {
	Enums.ArrowType.DEFAULT: preload("res://assets/textures/default_head_icon.png"),
	Enums.ArrowType.GOLD: preload("res://assets/textures/gold_head_icon.png"),
	Enums.ArrowType.DIAMOND: preload("res://assets/textures/diamond_head_icon.png")
}
var arrowType: int = Enums.ArrowType.DEFAULT setget setType
var numArrows: int = 0 setget setAmount

func setType(type):
	arrowType = type
	texButton.texture_normal = Util.entry(texMapping, type, texMapping[Enums.ArrowType.DEFAULT])

func setAmount(num):
	numArrows = num
	if num == INF:
		label.text = ""
	else:
		label.text = num as String
