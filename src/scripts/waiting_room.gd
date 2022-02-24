extends Popup

onready var player_list = $CenterContainer/VBoxContainer/ItemList


func _ready() -> void:
	player_list.clear()


func refresh_players(players) -> void:
	player_list.clear()
	for player_id in players:
		var player = players[player_id]["Player_name"]
		player_list.add_item(player, null, false)
