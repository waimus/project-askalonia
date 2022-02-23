extends Node


var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var ip : String = "127.0.0.1"
var port : int = 42069


func _ready() -> void:
	connect_to_server()


func connect_to_server() -> void:
	network.create_client(ip, port)
	get_tree().set_network_peer(network)
	print("initializing network")
	
	network.connect("connection_succeeded", self, "_on_connection_succeeded")
	network.connect("connection_failed", self, "_on_connection_failed")


func _on_connection_succeeded() -> void:
	print("client connected to server")


func _on_connection_failed() -> void:
	print("unable to connect to server")
