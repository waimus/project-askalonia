extends Area

export(NodePath) var DoorNode : NodePath
export(bool) var UseCustomShape : bool
export(Vector3) var AreaSize : Vector3 = Vector3(1, 1, 1)

onready var area_collision : CollisionShape = $CollisionShape

var door_object : Spatial


func _ready():
	if UseCustomShape:
		var area_shape = BoxShape.new()
		area_shape.set_extents(AreaSize)
		
		area_collision.set_shape(area_shape)
	
	door_object = get_node(DoorNode)


func _on_trigger_body_entered(body):
	if body.is_in_group("Players"):
		var door_animation : AnimationPlayer = door_object.get_node("AnimationPlayer")
		door_animation.play("door_open")


func _on_trigger_body_exited(body):
	if body.is_in_group("Players"):
		var door_animation : AnimationPlayer = door_object.get_node("AnimationPlayer")
		door_animation.play_backwards("door_open")
