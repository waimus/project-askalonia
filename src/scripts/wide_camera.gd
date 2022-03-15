extends Spatial


export(NodePath) var player_1_node : NodePath
export(NodePath) var player_2_node : NodePath

onready var wide_camera = $WideCamera

var player_1 : Spatial
var player_2 : Spatial
var players_distance : float = 0
var dynamic_fov : float = 70


func _ready():
	player_1 = get_node(player_1_node)
	player_2 = get_node(player_2_node)


func _process(delta):
	self.translation = (player_1.translation + player_2.translation) * 0.5
	
	players_distance = player_1.translation.distance_to(player_2.translation)
	dynamic_fov = lerp(40, 110, players_distance / 50)
	wide_camera.set_fov(dynamic_fov)