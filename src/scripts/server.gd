extends Node


const DEFAULT_IP = "127.0.0.1"
const DEFAULT_PORT = 28940

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var selected_ip
var selected_port

var local_player_id = 0
sync var players = {}
sync var player_data = {}


func _ready() -> void:
	get_tree().connect("network_peer_connected", self, "_on_player_connected")
	get_tree().connect("network_peer_disconnected", self, "_on_player_disconnected")
	get_tree().connect("connection_failed", self, "_on_connection_failed")
	get_tree().connect("server_disconnected", self, "_on_server_disconnected")


func connect_to_server() -> void:
	get_tree().connect("connected_to_server", self, "_on_connection_ok")
	network.create_client(selected_ip, selected_port)
	get_tree().set_network_peer(network)


func _on_player_connected(id) -> void:
	print("client %s connected" % str(id))


func _on_player_disconnected(id) -> void:
	print("client %s disconnected" % str(id))


func _on_connection_ok() -> void:
	print("successfully connected to server")
	register_player()
	rpc_id(1, "send_player_info", local_player_id, player_data)


func _on_connection_failed() -> void:
	print("failed to connected to server")


func _on_server_disconnected() -> void:
	print("network has been disconnected from server")


func register_player() -> void:
	local_player_id = get_tree().get_network_unique_id()
	player_data = Save.save_data
	players[local_player_id] = player_data


sync func update_waiting_room() -> void:
	get_tree().call_group("WaitingRoom", "refresh_players", players)
