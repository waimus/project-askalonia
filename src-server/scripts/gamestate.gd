extends Node


const PLAYER = preload("res://scenes/objects/player.tscn")

onready var players = $Players


remote func spawn_players(id):
	var player = PLAYER.instance()
	player.name = str(id)
	players.add_child(player)
	rpc("spawn_player", id)
