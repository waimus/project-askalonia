extends Popup


onready var player_list = $CenterContainer/VBoxContainer/ItemList


func _ready() -> void:
	player_list.clear()
	
	get_tree().get_root().connect("size_changed", self, "_on_window_resized")


# Resize popup element on window resize
func _on_window_resized():
	rect_size = get_viewport().get_size()


func refresh_players(players) -> void:
	player_list.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
