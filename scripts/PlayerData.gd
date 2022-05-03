class_name PlayerData

var coins: int = 0
var lastPlayedDate: Dictionary = OS.get_datetime_from_unix_time(OS.get_unix_time())
var scores: Dictionary = {
	Enums.GameMode.FREE_PLAY: [[]],
	Enums.GameMode.STANDARD: [[]],
	Enums.GameMode.TIME_ATTACK: [[]]
}
var quiver: Dictionary = {
	Enums.ArrowType.GOLD: 0,
	Enums.ArrowType.DIAMOND: 0
}

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
		"quiver": quiver
	}

func deserialize(dict: Dictionary):
	coins = Util.entry(dict, "coins", 0)
	lastPlayedDate = OS.get_datetime_from_unix_time(Util.entry(dict, "lastPlayedDate", OS.get_unix_time()))
	quiver = Util.entry(dict, "quiver", {
		Enums.ArrowType.GOLD: 0,
		Enums.ArrowType.DIAMOND: 0
	})
	var score_dict = Util.entry(dict, "scores", {
		Enums.GameMode.FREE_PLAY: [[]],
		Enums.GameMode.STANDARD: [[]],
		Enums.GameMode.TIME_ATTACK: [[]]
	})
	scores = {
		Enums.GameMode.FREE_PLAY: deserialize_scores(score_dict[Enums.GameMode.FREE_PLAY]),
		Enums.GameMode.STANDARD: deserialize_scores(score_dict[Enums.GameMode.STANDARD]),
		Enums.GameMode.TIME_ATTACK: deserialize_scores(score_dict[Enums.GameMode.TIME_ATTACK])
	}
