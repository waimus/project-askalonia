extends Control


onready var main_menu : String = "res://scenes/worlds/menu_main.tscn"


func _on_button_back_pressed():
	print("button: back")
	get_tree().change_scene(main_menu)
