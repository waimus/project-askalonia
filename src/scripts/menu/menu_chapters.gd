extends Control


onready var menu_scene : String = "res://scenes/worlds/menu_main.tscn"
onready var chapter_one : String = "res://scenes/worlds/chapter_1/ChapterOne_World.tscn"


func _on_button_back_pressed():
	print("button: back")
	get_tree().change_scene(menu_scene)


func _on_button_c1_pressed():
	print("button: chapter 1")
	get_tree().change_scene(chapter_one)


func _on_button_c2_pressed():
	print("button: unimplemented chapter 2")


func _on_button_c3_pressed():
	print("button: unimplemented chapter 3")
