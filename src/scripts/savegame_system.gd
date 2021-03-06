extends Node


# User filesystem location, see: https://godotengine.org/qa/4351/where-are-user-locations-on-each-platform
# Godot Flatpak is at ~/.var/app/org.godotengine.Godot/data/godot/app_userdata/askalonia
const SAVE_PATH = "user://savedata.dat"


# Courtesy of https://docs.godotengine.org/en/3.4/tutorials/io/saving_games.html (CC BY 3.0)
func save_game():
	var save_game = File.new()
	save_game.open(SAVE_PATH, File.WRITE)
	var save_nodes = get_tree().get_nodes_in_group("Presistent")
	for node in save_nodes:
		# Check the node is an instanced scene so it can be instanced again during load.
		if node.filename.empty():
			print("persistent node '%s' is not an instanced scene, skipped" % node.name)
			continue

		# Check the node has a save function.
		if !node.has_method("save_node_state"):
			print("persistent node '%s' is missing a save_node_state() function, skipped" % node.name)
			continue

		# Call the node's save function.
		var node_data = node.call("save_node_state")

		# Store the save dictionary as a new line in the save file.
		save_game.store_line(to_json(node_data))
	save_game.close()


# ISSUE: loading game emptied $SAVE_PATH file somehow and then complains the data couldn't be found
func load_game():
	var save_game = File.new()
	if not save_game.file_exists(SAVE_PATH):
		return # Error! We don't have a save to load.

	# We need to revert the game state so we're not cloning objects
	# during loading. This will vary wildly depending on the needs of a
	# project, so take care with this step.
	# For our example, we will accomplish this by deleting saveable objects.
	var save_nodes = get_tree().get_nodes_in_group("Presistent")
	for i in save_nodes:
		i.queue_free()

	# Load the file line by line and process that dictionary to restore
	# the object it represents.
	save_game.open(SAVE_PATH, File.READ)
	while save_game.get_position() < save_game.get_len():
		# Get the saved dictionary from the next line in the save file
		var node_data = parse_json(save_game.get_line())

		# Firstly, we need to create the object and add it to the tree and set its position.
		var new_object = load(node_data["filename"]).instance()
		get_node(node_data["parent"]).add_child(new_object)
		new_object.transform.origin = Vector3(node_data["pos_x"], node_data["pos_y"], node_data["pos_z"])

		# Now we set the remaining variables.
		for i in node_data.keys():
			if i == "filename" or i == "parent" or i == "pos_x" or i == "pos_y" or i == "pos_z":
				continue
			new_object.set(i, node_data[i])

	save_game.close()
