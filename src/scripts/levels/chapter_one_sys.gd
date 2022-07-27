extends Spatial


export(NodePath) var camera_rig_path : NodePath
export(NodePath) var food_pickup_timer_path : NodePath

export(NodePath) var checkbox1_path : NodePath
export(NodePath) var checkbox2_path : NodePath
export(NodePath) var checkbox3_path : NodePath
export(NodePath) var checkbox4_path : NodePath
export(NodePath) var checkbox5_path : NodePath
export(NodePath) var checkbox6_path : NodePath

export(bool) var obj1_boxes : bool = false
export(bool) var obj2_roadboxes : bool = false
export(bool) var obj3_player2_rest : bool = false
export(bool) var obj4_pickup_food : bool = false
export(bool) var obj5_return : bool = false
export(bool) var obj6_exit : bool = false

onready var obj1_checkbox : CheckBox
onready var obj2_checkbox : CheckBox
onready var obj3_checkbox : CheckBox
onready var obj4_checkbox : CheckBox
onready var obj5_checkbox : CheckBox
onready var obj6_checkbox : CheckBox

var camera_rig : Spatial
var food_pickup_timer : Timer


# Ready
func _ready() -> void:
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), AskaloniaGlobals.ui_scaling / 100)
	if !camera_rig:
		camera_rig = get_node(camera_rig_path)
	if !food_pickup_timer:
		food_pickup_timer = get_node(food_pickup_timer_path)
	
	obj1_checkbox = get_node(checkbox1_path)
	obj2_checkbox = get_node(checkbox2_path)
	obj3_checkbox = get_node(checkbox3_path)
	obj4_checkbox = get_node(checkbox4_path)
	obj5_checkbox = get_node(checkbox5_path)
	obj6_checkbox = get_node(checkbox6_path)


func _process(delta):
	obj1_checkbox.pressed = obj1_boxes
	obj2_checkbox.pressed = obj2_roadboxes
	obj3_checkbox.pressed = obj3_player2_rest
	obj4_checkbox.pressed = obj4_pickup_food
	obj5_checkbox.pressed = obj5_return
	obj6_checkbox.pressed = obj6_exit


func _unhandled_input(event) -> void:
	if event.is_action_pressed("game_kill"):
		get_tree().change_scene("res://scenes/worlds/menu_main.tscn")


func print_objectives() -> void:
	var objectives_array : Array = [
		obj1_boxes,
		obj2_roadboxes,
		obj3_player2_rest,
		obj4_pickup_food,
		obj5_return,
		obj6_exit,
	]
	
	printt("objectives:", objectives_array)


# Objective 1 config
var boxes_count : int = 0


func _on_AreaBoxesPlacement_body_entered(body) -> void:
	if body.is_in_group("Pickable"):
		boxes_count += 1


func _on_AreaBoxesPlacement_body_exited(body) -> void:
	if body.is_in_group("Pickable"):
		boxes_count -= 1
	if body.is_in_group("Players"):
		if boxes_count >= 5:
			obj1_boxes = true
		else:
			obj1_boxes = false
		
		print("current boxes of objective 1: %s, objective completed? %s" % [String(boxes_count), obj1_boxes])
		print_objectives()


# Objectives 2 config
var roadboxes_count : int = 0


func _on_AreaRoadBoxes_body_entered(body) -> void:
	if body.is_in_group("Objective 2"):
		roadboxes_count += 1


func _on_AreaRoadBoxes_body_exited(body) -> void:
	if body.is_in_group("Objective 2"):
		roadboxes_count -= 1
	if body.is_in_group("Players"):
		if roadboxes_count >= 4:
			obj2_roadboxes = true
		else:
			obj2_roadboxes = false
		
		print("current boxes of objective 2: %s, objective completed? %s" % [String(roadboxes_count), obj2_roadboxes])
		print_objectives()


# Objective 3 config
func _on_AreaRest_body_entered(body) -> void:
	if body.is_in_group("Player 2"):
		obj3_player2_rest = true
		camera_rig.player_one_focus = true
		
		# Disable camera bound
		if camera_rig.bound_collisions:
			for c in camera_rig.bound_collisions:
				c.disabled = true
		
		print("Objective 3 completed? %s" % obj3_player2_rest)
		print_objectives()
	if body.is_in_group("Player 1"):
		if obj4_pickup_food:
			obj5_return = true
			
			print("Objective 5 completed? %s" % obj3_player2_rest)
		else:
			obj5_return = false
		
		print_objectives()


func _on_AreaRest_body_exited(body) -> void:
	if body.is_in_group("Player 2"):
		# Leave this objective true when obj4 is already true
		if obj4_pickup_food:
			obj3_player2_rest = true
		else:
			obj3_player2_rest = false
		
		camera_rig.player_one_focus = false
		
		# Re-enable camera bound
		if camera_rig.bound_collisions:
			for c in camera_rig.bound_collisions:
				c.disabled = false
		
		print("Objective 3 completed? %s" % obj3_player2_rest)
		print_objectives()


# Objective 4 config
func _on_AreaPickupFood_body_entered(body) -> void:
	if body.is_in_group("Player 1"):
		food_pickup_timer.start()
		print("Start picking food, wait for timer . . .")
		print("Objective 4 completed? %s" % obj4_pickup_food)
		print_objectives()


func _on_FoodPickTimer_timeout() -> void:
	obj4_pickup_food = true
	print("food picked up")
	print("Objective 4 completed? %s" % obj4_pickup_food)
	print_objectives()


# Objective 5 config: exit
onready var exit_timeout : Timer = $ExitTimeout


func _on_AreaExit_body_entered(body):
	if body.is_in_group("Players"):
		var objectives_array : Array = [
			obj1_boxes,
			obj2_roadboxes,
			obj3_player2_rest,
			obj4_pickup_food,
			obj5_return,
		]
		
		if objectives_array.find(false) == -1:
			printt("every objectives completed", objectives_array.find(true))
			obj6_exit = true
			
			# Start timer before redirecting to next screen
			exit_timeout.start()
		else:
			print("something incomplete")
			obj6_exit = false


func _on_ExitTimeout_timeout():
	print("Chapter 1 completed!")
	# currently returns to menu
	get_tree().change_scene("res://scenes/worlds/menu_main.tscn")
