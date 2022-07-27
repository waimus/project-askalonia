extends RigidBody


func _physics_process(delta):
	if is_network_master():
		rpc_unreliable_id(1, "update_transform", global_transform)


remote func update_remote_transform(transform):
	if not is_network_master():
		global_transform = transform
