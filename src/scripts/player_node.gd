extends KinematicBody


export(bool) var player_one : bool = true
export(NodePath) var ActiveCameraNode : NodePath

var camera_pivot : Spatial
var camera : Camera

var world_gravity : Vector3 = Vector3.DOWN * 10.0
var move_speed : float = 7.0
var sprint_speed : float = 12.0
var jump_force : float = 25.0

var move_velocity : Vector3 = Vector3.ZERO

var fw : bool
var bw : bool
var lt : bool
var rt : bool
var sprint : bool


func _ready() -> void:
	camera_pivot = get_node(ActiveCameraNode)
	camera = camera_pivot.get_node("WideCamera")
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), Globals.ui_scaling)


func _process(delta) -> void:
	configure_helper()
	
	# Rotate player mesh to velocity direction
	$PlayerMesh.rotation.y = lerp_angle( $PlayerMesh.rotation.y, atan2($Helpers/Velocity.transform.origin.x, $Helpers/Velocity.transform.origin.z), 1)


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


func _unhandled_input(event):
	if player_one:
		fw = Input.is_action_pressed("pl1_move_forward")
		bw = Input.is_action_pressed("pl1_move_backward")
		rt = Input.is_action_pressed("pl1_move_right")
		lt = Input.is_action_pressed("pl1_move_left")
		sprint = Input.is_action_pressed("pl1_move_sprint")
	else:
		fw = Input.is_action_pressed("pl2_move_forward")
		bw = Input.is_action_pressed("pl2_move_backward")
		rt = Input.is_action_pressed("pl2_move_right")
		lt = Input.is_action_pressed("pl2_move_left")
		sprint = Input.is_action_pressed("pl2_move_sprint")


func get_input(delta : float) -> void:
	var camera_forward = camera.transform.basis.z.normalized()
	var vy = move_velocity.y
	move_velocity = Vector3.ZERO
	
	# Select which speed used depends on sprint key input
	var speed_multiplier : float = move_speed
	if sprint:
		speed_multiplier = sprint_speed
	else:
		speed_multiplier = move_speed
	
	if fw:
		move_velocity += -camera_forward * speed_multiplier
	if bw:
		move_velocity += camera_forward  * speed_multiplier
	if lt:
		move_velocity += camera_forward.cross(Vector3.UP) * speed_multiplier
	if rt:
		move_velocity += -camera_forward.cross(Vector3.UP) * speed_multiplier
	
	move_velocity.y = vy


func configure_helper() -> void:
	var x : float = move_velocity.x
	var z : float = move_velocity.z
	
	# Place helper to the velocity direction
	if move_velocity.abs() > Vector3(0.1, 0.1, 0.1):
		$Helpers/Velocity.transform.origin = Vector3(x, 0, z).normalized() * 4
	# Special case for the Z axis, manually check velocity and place the helper
	elif move_velocity.z < -0.1:
		$Helpers/Velocity.transform.origin = Vector3(0, 0, -4)
	elif move_velocity.z > 0.1:
		$Helpers/Velocity.transform.origin = Vector3(0, 0, 4)

