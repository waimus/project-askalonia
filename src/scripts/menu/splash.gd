extends Control


onready var wait_time : Timer = $WaitTimer
onready var splash_player : AnimationPlayer = $AnimationPlayer
onready var main_menu : String = "res://scenes/worlds/menu_main.tscn"


func _ready():
	wait_time.start()
	splash_player.play("Splash")


func _process(delta):
	if wait_time.is_stopped():
		get_tree().change_scene(main_menu)
