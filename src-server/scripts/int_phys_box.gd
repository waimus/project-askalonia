extends Node


remote func update_transform(transform):
	rpc_unreliable("update_remote_transform", transform)
