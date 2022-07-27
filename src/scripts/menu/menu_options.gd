extends Control


onready var main_menu : String = "res://scenes/worlds/menu_main.tscn"
onready var fullscreen_check : CheckButton = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer/CheckButton
onready var mouse_sensitivity_box : LineEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer3/LineEdit_MouseSensitivity
onready var global_ui_scaling_box : LineEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer2/LineEdit_UIScaling
onready var global_audio_volume_box : LineEdit = $Panel/VBoxContainer/HBoxContainer/VBoxContainer/HBoxContainer4/LineEdit_GlobalVolume


func _ready():
	# Set settings data from Globals singleton
	fullscreen_check.pressed = OS.is_window_fullscreen()
	mouse_sensitivity_box.text = String(AskaloniaGlobals.mouse_sensitivity)
	global_ui_scaling_box.text = String(AskaloniaGlobals.ui_scaling)


func _on_CheckButton_pressed():
	OS.window_fullscreen = fullscreen_check.pressed


func _on_LineEdit_MouseSensitivity_text_changed(new_text):
	AskaloniaGlobals.mouse_sensitivity = float(mouse_sensitivity_box.text)


func _on_LineEdit_UIScaling_text_changed(new_text):
	AskaloniaGlobals.ui_scaling = float(new_text)


func _on_button_quit_pressed():
	print("button: back")
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), AskaloniaGlobals.ui_scaling / 100)
	get_tree().change_scene(main_menu)
