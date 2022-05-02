class_name GameState

var gamemode: int = -1
var status: int = -1

var time_left = null
var quiver: Dictionary = {}
var wind: Vector3 = Vector3.ZERO
var gravity: Vector3 = Vector3(0, -0.15, 0)
var target_locations: Array = []

var displayed_scores: PoolStringArray = []
var scores: Array = []

# Anything else that a specific GameMode may need
var metadata: Dictionary = {}
