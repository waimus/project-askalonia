extends KinematicBody


export(bool) var player_one : bool = true
export(NodePath) var ActiveCameraNode : NodePath

var camera_pivot : Spatial
var camera : Camera

var world_gravity : Vector3 = Vector3.DOWN * 10.0
var move_speed : float = 8.0
var jump_force : float = 28.0

var move_velocity : Vector3 = Vector3.ZERO

var fw : bool
var bw : bool
var lt : bool
var rt : bool


func _ready() -> void:
	camera_pivot = get_node(ActiveCameraNode)
	camera = camera_pivot.get_node("WideCamera")
	
	$Helpers/VelocityHelper.set_as_toplevel(true)
	
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), Globals.ui_scaling)


func _process(delta) -> void:
	configure_helpers()


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
	else:
		fw = Input.is_action_pressed("pl2_move_forward")
		bw = Input.is_action_pressed("pl2_move_backward")
		rt = Input.is_action_pressed("pl2_move_right")
		lt = Input.is_action_pressed("pl2_move_left")


func get_input(delta : float) -> void:
	var camera_forward = camera.transform.basis.z.normalized()
	var vy = move_velocity.y
	move_velocity = Vector3.ZERO
	
	if fw:
		move_velocity += -camera_forward * move_speed
	if bw:
		move_velocity += camera_forward  * move_speed
	if lt:
		move_velocity += camera_forward.cross(Vector3.UP) * move_speed
	if rt:
		move_velocity += -camera_forward.cross(Vector3.UP) * move_speed
	
	move_velocity.y = vy


func configure_helpers() -> void:
	var moving : Array = [fw, bw, lt, rt]
	
	if !moving.has(true):
		var x : float = move_velocity.x
		var y : float = $Helpers/VelocityHelper.translation.y
		var z : float = move_velocity.z
		$Helpers/VelocityHelper.translation = Vector3(x, y, z).normalized()
	else:
		$Helpers/VelocityHelper.translation = Vector3(0, $Helpers/VelocityHelper.translation.y, 0)
