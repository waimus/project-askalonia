extends Spatial


export(NodePath) var player_1_node : NodePath
export(NodePath) var player_2_node : NodePath

onready var wide_camera = $WideCamera

var player_1 : Spatial
var player_2 : Spatial
var players_distance : float = 0
var dynamic_fov : float = 70


func _ready() -> void:
	player_1 = get_node(player_1_node)
	player_2 = get_node(player_2_node)


func _process(delta : float) -> void :
	self.translation = (player_1.translation + player_2.translation) * 0.5
	
	players_distance = player_1.translation.distance_to(player_2.translation)
	dynamic_fov = lerp(30, 115, players_distance / 100)
	
	if wide_camera.get_fov() < 120:
		wide_camera.set_fov(dynamic_fov)


func save_node_state() -> Dictionary:
	var save_dictionary = {
		"filename" : get_filename(),
		"parent" : get_parent().get_path(),
		"pos_x" : self.translation.x,
		"pos_y" : self.translation.y,
		"pos_z" : self.translation.z,
		"dynamic_fov" : self.dynamic_fov,
	}
	return save_dictionary
