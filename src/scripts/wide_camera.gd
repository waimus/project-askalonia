extends Spatial


export(NodePath) var player_1_node : NodePath
export(NodePath) var player_2_node : NodePath
export(bool) var player_one_focus : bool = false

onready var wide_camera = $WideCamera
onready var bounds = $PlayerBound

var bound_collisions : Array
var player_1 : Spatial
var player_2 : Spatial
var players_distance : float = 0
var dynamic_fov : float = 70


func _ready() -> void:
	player_1 = get_node(player_1_node)
	player_2 = get_node(player_2_node)
	
	if bounds:
		bound_collisions = bounds.get_children()


func _process(delta : float) -> void :
	player_focus_configure()


func configure_camera(target_1 : Spatial, target_2 : Spatial, min_fov : float) -> void:
	self.translation = (target_1.translation + target_2.translation) * 0.5
	
	players_distance = target_1.translation.distance_to(target_2.translation)
	
	dynamic_fov = lerp(min_fov, 115, players_distance / 100)
	
	if wide_camera.get_fov() < 120:
		wide_camera.set_fov(dynamic_fov)


func player_focus_configure() -> void:
	# Set both target to player 1 when focusing to player 1
	if player_one_focus:
		configure_camera(player_1, player_1, 40)
	else:
		configure_camera(player_1, player_2, 30)


func save_node_state() -> Dictionary:
	var save_dictionary = {
		"filename" : self.get_filename(),
		"parent" : self.get_parent().get_path(),
		"pos_x" : self.translation.x,
		"pos_y" : self.translation.y,
		"pos_z" : self.translation.z,
		"dynamic_fov" : self.dynamic_fov,
	}
	return save_dictionary
