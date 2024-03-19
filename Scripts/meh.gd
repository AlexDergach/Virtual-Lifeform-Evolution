extends GridMap

var grid_size = Vector2(150, 150)  # Size of the grid map
var tile_size = Vector3(2, 1, 2)  # Size of each tile
var map_center = grid_size / 2  # Center of the grid map
var character_body = null

func _ready():
	generate_grid_map()
	spawn_character()

func generate_grid_map():
	var biome_map = []
	for x in range(int(grid_size.x)):
		var column = []
		for y in range(int(grid_size.y)):
			column.append(-1)
		biome_map.append(column)

	var biome_ids = { "Desert_Cube": 2, "Lava_Cube": 7, "Forest_Cube": 20}

	for biome_name in biome_ids.keys():
		var biome_id = biome_ids[biome_name]
		for i in range(10):  # Generate 10 random clusters for each biome
			var cluster_center = Vector2(randi_range(-map_center.x, map_center.x), randi_range(-map_center.y, map_center.y)) + map_center
			var cluster_radius = randi_range(15, 25)  # Reduce the cluster radius

			for x in range(int(grid_size.x)):
				for y in range(int(grid_size.y)):
					var distance_to_center = cluster_center.distance_to(Vector2(x, y))
					var random_factor = randf_range(0.5, 1.0)  # Add randomness to the inclusion probability
					var inclusion_probability = 1.0 - (distance_to_center / cluster_radius) * random_factor  # Adjust the probability based on distance and randomness
					if inclusion_probability > 0.5:  # Adjust the threshold for inclusion
						biome_map[x][y] = biome_id

	generate_rivers(biome_map)
	generate_lakes(biome_map)

	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			var biome_id = biome_map[x][y]
			if biome_id != -1:
				set_cell_item(Vector3(x, 0, y), biome_id)

	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			if biome_map[x][y] == 2:
				if randf() < 0.1:
					var cactus_position = Vector3(x, 1, y)
					set_cell_item(cactus_position, 0)

func generate_rivers(biome_map):
	for i in range(3):
		var start_x = randi_range(1, grid_size.x - 2)
		var end_x = randi_range(1, grid_size.x - 2)
		var y = randi_range(1, grid_size.y - 2)

		for river_x in range(start_x, end_x + 1):
			biome_map[river_x][y] = 2

func generate_lakes(biome_map):
	for i in range(2):
		var center_x = randi_range(2, grid_size.x - 3)
		var center_y = randi_range(2, grid_size.y - 3)

		for lake_x in range(center_x - 1, center_x + 2):
			for lake_y in range(center_y - 1, center_y + 2):
				biome_map[lake_x][lake_y] = 2

func spawn_character():
	# Find the Camera node in the scene tree
	var character_body = get_node("../Camera")
	if character_body:
		# Calculate the local position of the grid center relative to the Camera node
		var center_local_position = Vector3(map_center.x * tile_size.x, 5, map_center.y * tile_size.z)
		# Convert the local position to global position
		var center_world_position = self.to_global(center_local_position)
		# Set the character's global position to the calculated position
		character_body.global_transform.origin = center_world_position

