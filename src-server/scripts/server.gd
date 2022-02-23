extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var port : int = 42069
var max_players : int = 10


func _ready() -> void:
	start_server() 


func start_server() -> void:
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Askalonia dedicated server: started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id) -> void:
	print("user %s connected to the server" % str(player_id))


func _on_peer_disconnected(player_id) -> void:
	print("user %s disconnected from the server" % str(player_id))
