extends Control


onready var player_name = $CenterContainer/VBoxContainer/GridContainer/NameTextbox
onready var selected_ip = $CenterContainer/VBoxContainer/GridContainer/IPTextbox
onready var selected_port = $CenterContainer/VBoxContainer/GridContainer/PortTextbox
onready var waiting_room = $WaitingRoom
onready var ready_button = $WaitingRoom/CenterContainer/VBoxContainer/ReadyButton


func _ready() -> void:
	player_name.text = Save.save_data["Player_name"]
	selected_ip.text = Server.DEFAULT_IP
	selected_port.text = str(Server.DEFAULT_PORT)


func _on_connect_button_pressed() -> void:
	Server.selected_ip = selected_ip.text
	Server.selected_port = int(selected_port.text)
	Server.connect_to_server()
	
	show_waiting_room()


func _on_name_textbox_text_changed(new_text) -> void:
	Save.save_data["Player_name"] = player_name.text
	Save.save_game()


func show_waiting_room() -> void:
	waiting_room.popup()


func _on_ready_button_pressed() -> void:
	Server.load_game()
	ready_button.set_disabled(true)
