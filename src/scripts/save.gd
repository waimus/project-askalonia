extends Node


const SAVE_PATH = "user://savegame.json"

var save_data = {}


func _ready() -> void:
	save_data = get_data()


func get_data():
	var file = File.new()
	
	if not file.file_exists(SAVE_PATH):
		save_data = {"Player_name": "Unnamed"}
		save_game()
	file.open(SAVE_PATH, File.READ)
	var content = file.get_as_text()
	var data = parse_json(content)
	save_data = data
	file.close()
	return(data)


func save_game() -> void:
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	save_game.store_line(to_json(save_data))
