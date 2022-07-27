extends Spatial


var body_count = 0


func _on_area_body_entered(body):
	if body is KinematicBody or body is RigidBody:
		body_count += 1
		if body_count == 1:
			$AnimationPlayer.play("door_open")


func _on_area_body_exited(body):
	if body is KinematicBody or body is RigidBody:
		if body_count == 1:
			$AnimationPlayer.play_backwards("door_open")
		body_count -= 1
