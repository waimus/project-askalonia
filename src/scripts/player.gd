extends KinematicBody


onready var player_camera : Spatial = $CameraPivot

var world_gravity : Vector3 = Vector3.DOWN * 10.0
var move_speed : float = 8.0
var jump_force : float = 28.0

var move_velocity : Vector3 = Vector3.ZERO


func _process(delta) -> void:
	rotate_y(Globals.mouse_offset.x * -1)
	player_camera.rotate_x(Globals.mouse_offset.z * -1)


func _physics_process(delta) -> void:
	move_velocity += world_gravity * delta
	get_input(delta)
	move_velocity = move_and_slide(move_velocity, Vector3.UP)
	
	if Input.is_action_just_pressed("pl_move_jump"):
		if self.is_on_floor():
			move_velocity.y = jump_force
	
	if !self.is_on_floor() and move_velocity.y < 0:
		world_gravity = Vector3.DOWN * 90.0


func get_input(delta) -> void:
	var vy = move_velocity.y
	move_velocity = Vector3.ZERO
	
	if Input.is_action_pressed("pl_move_forward"):
		move_velocity += -transform.basis.z * move_speed
	if Input.is_action_pressed("pl_move_backward"):
		move_velocity += transform.basis.z * move_speed
	if Input.is_action_pressed("pl_move_left"):
		move_velocity += -transform.basis.x * move_speed
	if Input.is_action_pressed("pl_move_right"):
		move_velocity += transform.basis.x * move_speed
	move_velocity.y = vy
	
