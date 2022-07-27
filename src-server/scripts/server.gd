extends Node


onready var port_textbox = $CenterContainer/VBoxContainer/GridContainer/PortTextbox
onready var logs_list = $CenterContainer/VBoxContainer/Scroll/LogsList
onready var server_start_button = $CenterContainer/VBoxContainer/StartButton

var network : NetworkedMultiplayerENet = NetworkedMultiplayerENet.new()
var port : int = 28940
var max_players : int = 10

var players = {}
var ready_players = 0


func _ready() -> void:
	port_textbox.text = str(port)
	logs_list.clear()


func start_server() -> void:
	network.create_server(port, max_players)
	get_tree().set_network_peer(network)
	
	# View server local address to log
	var addresses = IP.get_local_addresses()
	print_log("server started on: ")
	for a in addresses:
		print_log(str(a))
	
	network.connect("peer_connected", self, "_on_peer_connected")
	network.connect("peer_disconnected", self, "_on_peer_disconnected")


func kill_server() -> void:
	rpc("kill_client")
	print_log("killing server . . .")
	get_tree().network_peer = null


func _on_peer_connected(player_id) -> void:
	print_log("client %s connected to the server" % str(player_id))


func _on_peer_disconnected(player_id) -> void:
	print_log("client %s disconnected from the server" % str(player_id))


remote func send_player_info(id, player_data) -> void:
	players[id] = player_data
	rset("players", players)
	rpc("update_waiting_room")


remote func load_world() -> void:
	ready_players += 1
	if players.size() > 1 and ready_players >= players.size():
		rpc("start_game")
		var world = preload("res://scenes/worlds/demo/demo.tscn").instance()
		get_tree().get_root().add_child(world)


func print_log(message: String) -> void:
	print(message)
	logs_list.add_item(message, null, false)


func _on_start_button_pressed():
	if get_tree().get_network_peer() == null: 
		port = int(port_textbox.text)
		start_server()
		server_start_button.set_text("Stop server")
	else:
		kill_server()
		server_start_button.set_text("Start server")
