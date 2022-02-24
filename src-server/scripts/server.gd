extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var port : int = 28940
var max_players : int = 10

var players = {}


func _ready() -> void:
	start_server() 


func start_server() -> void:
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	print("Askalonia dedicated server: started")
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func _on_peer_connected(player_id) -> void:
	print("client %s connected to the server" % str(player_id))


func _on_peer_disconnected(player_id) -> void:
	print("client %s disconnected from the server" % str(player_id))


remote func send_player_info(id, player_data) -> void:
	players[id] = player_data
	rset("players", players)
	rpc("update_waiting_room")

