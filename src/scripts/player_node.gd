extends KinematicBody


export(bool) var player_one : bool = true
export(NodePath) var ActiveCameraNode : NodePath

onready var raycast_pickup : RayCast = $PlayerMesh/RayCastPickup
onready var grab_attachment_point : Spatial = $PlayerMesh/GrabAttachement
onready var pickup_cooldown : Timer = $Helpers/PickupCooldown

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
var pickup : bool

var pickable_body : Spatial
var pickable_previous_parent : Spatial


func _ready() -> void:
	if ActiveCameraNode:
		camera_pivot = get_node(ActiveCameraNode)
		camera = camera_pivot.get_node("WideCamera")
	
	get_tree().set_screen_stretch(SceneTree.STRETCH_MODE_2D, SceneTree.STRETCH_ASPECT_EXPAND, Vector2(1280, 720), AskaloniaGlobals.ui_scaling)


func _process(delta) -> void:
	configure_helper()
	handle_drop_pickables()
	
	# Rotate player mesh to velocity direction
	$PlayerMesh.rotation.y = lerp_angle( $PlayerMesh.rotation.y, atan2($Helpers/Velocity.transform.origin.x, $Helpers/Velocity.transform.origin.z), 1)


func _physics_process(delta : float) -> void:
	process_input(delta)
	
	# Picking up pickables
	# TODO: can steal other players' picked object but the other player is still in picking state
	#		which the transform offset does not changed and the other player can drop it remotely
	if raycast_pickup.is_colliding():
		pickable_body = raycast_pickup.get_collider()
		
		if pickable_body.is_in_group("Pickable") and pickup_cooldown.is_stopped():
			print("%s is pickable" % pickable_body)
			
			if grab_attachment_point.get_child_count() <= 0:
				pickable_previous_parent = pickable_body.get_parent()
				pickable_previous_parent.remove_child(pickable_body)
				grab_attachment_point.add_child(pickable_body)
				
				# Reset transformation
				pickable_body.transform.origin = Vector3.ZERO
				pickable_body.rotation_degrees = Vector3.ZERO
				pickup_cooldown.start()
			else:
				print("Can't pick more than one object")
		else:
			# Remove invalid pickable_body to be able to pick new object
			pickable_body = null
			print("raycasted object is not pickable")


func _unhandled_input(event):
	if player_one:
		fw = Input.is_action_pressed("pl1_move_forward")
		bw = Input.is_action_pressed("pl1_move_backward")
		rt = Input.is_action_pressed("pl1_move_right")
		lt = Input.is_action_pressed("pl1_move_left")
		sprint = Input.is_action_pressed("pl1_move_sprint")
		pickup = Input.is_action_just_pressed("pl1_use_func")
		
		raycast_pickup.set_enabled(pickup)
	else:
		fw = Input.is_action_pressed("pl2_move_forward")
		bw = Input.is_action_pressed("pl2_move_backward")
		rt = Input.is_action_pressed("pl2_move_right")
		lt = Input.is_action_pressed("pl2_move_left")
		sprint = Input.is_action_pressed("pl2_move_sprint")
		pickup = Input.is_action_pressed("pl2_use_func")
		
		raycast_pickup.set_enabled(pickup)


func process_input(delta : float) -> void:
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
	var camera_forward : Vector3
	if camera:
		camera_forward = camera.transform.basis.z.normalized()
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


func handle_drop_pickables() -> void:
	if pickup and pickable_body:
		if pickup_cooldown.is_stopped() and grab_attachment_point.get_child_count() > 0:
			grab_attachment_point.remove_child(pickable_body)
			pickable_previous_parent.add_child(pickable_body)
			
			pickable_body.global_transform.origin = grab_attachment_point.global_transform.origin + (Vector3.UP * 0.0)
			
			if pickable_body:
				pickable_body = null
			
			if !pickup_cooldown.is_stopped():
				pickup_cooldown.stop()
			pickup_cooldown.start()


func save_node_state() -> Dictionary:
	var save_dictionary = {
		"filename" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : self.translation.x,
		"pos_y" : self.translation.y,
		"pos_z" : self.translation.z,
		"active_camera_node" : get_node(ActiveCameraNode).get_path(),
#		"camera_pivot" : self.camera_pivot.get_filename(),
#		"camera" : self.camera.get_filename(),
		"is_player_one" : self.player_one,
	}
	return save_dictionary

