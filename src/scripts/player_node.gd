extends KinematicBody


export(bool) var player_one : bool = true

onready var camera_pivot : Spatial = $CameraPivot

var world_gravity : Vector3 = Vector3.DOWN * 10.0
var move_speed : float = 8.0
var jump_force : float = 28.0

var move_velocity : Vector3 = Vector3.ZERO


func _ready() -> void:
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), Globals.ui_scaling)


func _process(delta) -> void:
	pass
#	rotate_y(Globals.mouse_offset.x * -1)
#	camera_pivot.rotate_x(Globals.mouse_offset.z * -1)


func _physics_process(delta) -> void:
	move_velocity += world_gravity * delta
	get_input(delta)
	move_velocity = move_and_slide(move_velocity, Vector3.UP)
	
	if player_one:
		if Input.is_action_just_pressed("pl1_move_jump"):
			if self.is_on_floor():
				move_velocity.y = jump_force

		if !self.is_on_floor() and move_velocity.y < 0:
			world_gravity = Vector3.DOWN * 90.0
	else:
		if Input.is_action_just_pressed("pl2_move_jump"):
			if self.is_on_floor():
				move_velocity.y = jump_force

		if !self.is_on_floor() and move_velocity.y < 0:
			world_gravity = Vector3.DOWN * 90.0


func get_input(delta : float) -> void:
	var vy = move_velocity.y
	move_velocity = Vector3.ZERO
	
	if player_one:
		var fw : bool = Input.is_action_pressed("pl1_move_forward")
		var bw : bool = Input.is_action_pressed("pl1_move_backward")
		var rt : bool = Input.is_action_pressed("pl1_move_right")
		var lt : bool = Input.is_action_pressed("pl1_move_left")
		
		if fw:
			move_velocity += -transform.basis.z * move_speed
		if bw:
			move_velocity += transform.basis.z * move_speed
		if lt:
			move_velocity += -transform.basis.x * move_speed
		if rt:
			move_velocity += transform.basis.x * move_speed
	else:
		var fw : bool = Input.is_action_pressed("pl2_move_forward")
		var bw : bool = Input.is_action_pressed("pl2_move_backward")
		var rt : bool = Input.is_action_pressed("pl2_move_right")
		var lt : bool = Input.is_action_pressed("pl2_move_left")
		
		if fw:
			move_velocity += -transform.basis.z * move_speed
		if bw:
			move_velocity += transform.basis.z * move_speed
		if lt:
			move_velocity += -transform.basis.x * move_speed
		if rt:
			move_velocity += transform.basis.x * move_speed
	
	move_velocity.y = vy
