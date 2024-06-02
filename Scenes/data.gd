extends Node

var high_score : int = 0

func save_game():
	var save_file = FileAccess.open_encrypted_with_pass("user://colourcascade.save", FileAccess.WRITE, "idc")
	var json_str = JSON.stringify(dict())
	save_file.store_line(json_str)
	return

func dict():
	var d = {
		"high_score" : high_score
	}
	return d

func load_game():
	if not FileAccess.file_exists("user://colourcascade.save"):
		print("NO DATA")
		return null
	
	var save_file = FileAccess.open_encrypted_with_pass("user://colourcascade.save", FileAccess.READ, "idc")
	
	while save_file.get_position() < save_file.get_length():
		var json_str = save_file.get_line()
		var json = JSON.new()
		var parse_result = json.parse(json_str)
		var node_data = json.get_data()
		return node_data

func recover_data():
	var loaded_game = load_game()
	if loaded_game != null:
		high_score = loaded_game["high_score"]

func reset_data():
	high_score = 0
	save_game()
	recover_data()
