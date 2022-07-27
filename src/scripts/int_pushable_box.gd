extends KinematicBody


onready var front_offset : Spatial = $AreaFront/PlayerOffset
onready var back_offset : Spatial = $AreaBack/PlayerOffset
onready var right_offset : Spatial = $AreaRight/PlayerOffset
onready var left_offset : Spatial = $AreaLeft/PlayerOffset
onready var move_timer : Timer = $MoveTimer

var direction : Vector3 = Vector3.ZERO
var interactible : bool = false
var interacting_body : KinematicBody
var body_position : Vector3
var selected_offset : Spatial


func _process(delta : float) -> void:
	if interactible and move_timer.is_stopped():
		# Only do when any player is inside the trigger
		if !interacting_body:
			return

		if interacting_body.player_one and Input.is_action_just_pressed("pl1_use_func"):
			move_timer.start()
		if !interacting_body.player_one and Input.is_action_just_pressed("pl2_use_func"):
			move_timer.start()


func _physics_process(delta) -> void:
	if !move_timer.is_stopped() and interactible:
		start_interpolate_position(delta)


func start_interpolate_position(delta: float) -> void:
	var start_position = self.global_transform.origin
	var target_position = self.global_transform.origin + direction * 1
	var interpolation_speed = 2 * delta
	
	self.global_transform.origin = lerp(start_position, target_position, interpolation_speed)
	
	# Move the player too
	interacting_body.global_transform.origin = lerp(interacting_body.global_transform.origin, selected_offset.global_transform.origin, interpolation_speed)


func set_direction(body : Spatial, dir : Vector3, offset : Spatial) -> void:
	interactible = true
	direction = dir
	selected_offset = offset

	if !interacting_body:
		interacting_body = body


func unset_direction(body : Spatial) -> void:
	# In any case other player passing through the trigger, ignore it.
	if body != interacting_body:
		return

	interactible = false
	
	if interacting_body:
		interacting_body = null


func _on_area_back_body_entered(body) -> void:
	if body.is_in_group("Players") and !interacting_body:
		set_direction(body, self.transform.basis.z, back_offset)


func _on_area_back_body_exited(body) -> void:
	if body.is_in_group("Players"):
		unset_direction(body)


func _on_area_front_body_entered(body) -> void:
	if body.is_in_group("Players") and !interacting_body:
		set_direction(body, -self.transform.basis.z, front_offset)


func _on_area_front_body_exited(body) -> void:
	if body.is_in_group("Players"):
		unset_direction(body)


func _on_area_right_body_entered(body) -> void:
	if body.is_in_group("Players") and !interacting_body:
		set_direction(body, self.transform.basis.x, right_offset)


func _on_area_right_body_exited(body) -> void:
	if body.is_in_group("Players"):
		unset_direction(body)


func _on_area_left_body_entered(body) -> void:
	if body.is_in_group("Players") and !interacting_body:
		set_direction(body, -self.transform.basis.x, left_offset)


func _on_area_left_body_exited(body) -> void:
	if body.is_in_group("Players"):
		unset_direction(body)
