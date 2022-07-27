extends Control


onready var start_new : String = "res://scenes/worlds/chapter_1/ChapterOne_World.tscn"
onready var chapter_select : String = "res://scenes/worlds/menu_chapters.tscn"
onready var game_options : String = "res://scenes/worlds/menu_options.tscn"
onready var game_credits : String = "res://scenes/worlds/menu_credits.tscn"


func _ready():
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), AskaloniaGlobals.ui_scaling / 100)


func _on_button_quit_pressed():
	get_tree().quit()


func _on_button_new_pressed():
	print("button: new game")
	get_tree().change_scene(start_new)


func _on_button_chapter_pressed():
	print("button: chapter select")
	get_tree().change_scene(chapter_select)


func _on_button_opt_pressed():
	print("button: options")
	get_tree().change_scene(game_options)


func _on_button_credits_pressed():
	print("button: credits")
	get_tree().change_scene(game_credits)
