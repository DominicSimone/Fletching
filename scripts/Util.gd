class_name Util

static func in_range(r: Array, v: float, clamped: bool = false) -> float:
	if clamped:
		return clamp(((r[1] - r[0]) * v) + r[0], r[0], r[1])
	return ((r[1] - r[0]) * v) + r[0] 

static func move(target: Spatial, from: Spatial, to: Spatial):
	var current_global_transform = target.global_transform
	from.remove_child(target)
	to.add_child(target)
	target.global_transform = current_global_transform

static func serialize_array(arr: Array) -> Array:
	var result = []
	for object in arr:
		result.append(object.serialize())
	return result

static func entry(dict: Dictionary, key: String, default):
	if key in dict:
		return dict[key]
	return default

static func sum_scores(scores: Array):
	var sum = 0
	for score in scores:
		sum += score.getValue()
	return sum

static func saveJSON(data, name):
	var file = File.new()
	file.open(name, File.WRITE)
	file.store_string(to_json(data))
	file.close()

static func loadJSON(name):
	var file = File.new()
	if file.file_exists(name):
		file.open(name, File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		match typeof(data):
			TYPE_ARRAY, TYPE_DICTIONARY:
				return data
			_:
				# printerr("Corrupted or unknown file format")
				return null
	else:
		# printerr("No saved data!")
		return null
