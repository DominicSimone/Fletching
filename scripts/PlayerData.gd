class_name PlayerData

var coins: int = 0
var lastPlayedDate: Dictionary = OS.get_datetime_from_unix_time(OS.get_unix_time())
var scores: Dictionary = {
	Enums.GameMode.FREE_PLAY: [],
	Enums.GameMode.STANDARD: [],
	Enums.GameMode.TIME_ATTACK: []
}
var quiver: Dictionary = {
	Enums.ArrowType.DEFAULT: INF,
	Enums.ArrowType.GOLD: 10,
	Enums.ArrowType.DIAMOND: 5
}

func add_score(new_score: Array, gamemode: int):
	var scores_value = Util.sum_scores(new_score)
	var numSavedScores = scores[gamemode].size()
	var i = numSavedScores
	var biggest = true
	while i > 0:
		i -= 1
		if scores_value < Util.sum_scores(scores[gamemode][i]):
			scores[gamemode].insert(i+1, new_score)
			biggest = false
			break
	if biggest:
		scores[gamemode].push_front(new_score)
	# Truncate to 10 scores
	if numSavedScores+1 > 10:
		scores[gamemode].resize(10)

func serialize_scores(array: Array) -> Array:
	var result = []
	for set_scores in array:
		result.append(Util.serialize_array(set_scores))
	return result

func deserialize_scores(array: Array) -> Array:
	var result = []
	for set_scores in array:
		var set_res = []
		for score in set_scores:
			var scoreObj = Score.new(0, 0, Vector3.ZERO)
			scoreObj.deserialize(score)
			set_res.append(scoreObj)
		result.append(set_res)
	return result

func serialize() -> Dictionary:
	return {
		"coins": coins,
		"lastPlayedDate": OS.get_unix_time(),
		"scores": {
			Enums.GameMode.FREE_PLAY: serialize_scores(scores[Enums.GameMode.FREE_PLAY]),
			Enums.GameMode.STANDARD: serialize_scores(scores[Enums.GameMode.STANDARD]),
			Enums.GameMode.TIME_ATTACK: serialize_scores(scores[Enums.GameMode.TIME_ATTACK])
		},
		"quiver": {
			Enums.ArrowType.GOLD: quiver[Enums.ArrowType.GOLD],
			Enums.ArrowType.DIAMOND: quiver[Enums.ArrowType.DIAMOND]
		}
	}

# Converting dict to JSON is an awful way to serialize/deserialize data in Godot. Enums are 
# converted from int to string (if key) during the process, Vector3 is converted to a formatted String, 
# there is no way to differentiate int from float, just all around terrible. 
# Try and use custom Resource objects in the next project.
func deserialize(dict: Dictionary):
	coins = Util.entry(dict, "coins", 0)
	lastPlayedDate = OS.get_datetime_from_unix_time(Util.entry(dict, "lastPlayedDate", OS.get_unix_time()))
	quiver = Util.entry(dict, "quiver", {
		Enums.ArrowType.GOLD: 0,
		Enums.ArrowType.DIAMOND: 0
	})
	quiver = {
		Enums.ArrowType.DEFAULT: INF,
		Enums.ArrowType.GOLD: quiver[Enums.ArrowType.GOLD as String],
		Enums.ArrowType.DIAMOND: quiver[Enums.ArrowType.DIAMOND as String]
	}
	var score_dict = Util.entry(dict, "scores", {
		Enums.GameMode.FREE_PLAY: [[]],
		Enums.GameMode.STANDARD: [[]],
		Enums.GameMode.TIME_ATTACK: [[]]
	})
	scores = {
		Enums.GameMode.FREE_PLAY: deserialize_scores(score_dict[Enums.GameMode.FREE_PLAY as String]),
		Enums.GameMode.STANDARD: deserialize_scores(score_dict[Enums.GameMode.STANDARD as String]),
		Enums.GameMode.TIME_ATTACK: deserialize_scores(score_dict[Enums.GameMode.TIME_ATTACK as String])
	}
