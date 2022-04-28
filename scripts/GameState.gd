class_name GameState

var gamemode: int = -1

var time_left = null
var quiver: Dictionary = {}
var wind: Vector3 = Vector3.ZERO

var displayed_score: int = 0
var scores: Array = []

# Anything else that a specific GameMode may need
var metadata: Dictionary = {}
