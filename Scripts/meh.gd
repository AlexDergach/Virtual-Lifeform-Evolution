extends GridMap

var grid_size = Vector2(300, 300)  # Size of the grid map
var tile_size = Vector3(2, 1, 2)  # Size of each tile
var map_center = grid_size / 2  # Center of the grid map
var character_body = null
var snow_island_spawned = false  # Track if a snow island has been spawned

func _ready():
	generate_biomes()
	spawn_character()

func generate_biomes():
	var biome_map = []

	# Initialize biome map
	for x in range(int(grid_size.x)):
		var column = []
		for y in range(int(grid_size.y)):
			column.append(-1)
		biome_map.append(column)

	var biome_ids = { "Desert_Cube": 2, "Lava_Cube": 7, "Forest_Cube": 20, "Ice_Cube": 12, "Stone_Cube": 18 }

	# Generate clusters for each biome
	for biome_name in biome_ids.keys():
		var biome_id = biome_ids[biome_name]
		var num_clusters = 10  # Adjust the number of clusters as needed

		# Determine clustering factor based on biome type
		var clustering_factor = 1.4
		if biome_id == 12 or biome_id == 18:  # Ice_Cube or Stone_Cube
			clustering_factor = 0.5  # Adjust the clustering factor for these biomes
		
		# Generate initial clusters
		for i in range(num_clusters):
			var cluster_center = Vector2(randf_range(0.0, grid_size.x), randf_range(0.0, grid_size.y))
			if !check_cluster_collision(biome_map, cluster_center, clustering_factor, biome_id):
				# Check if the biome is snow and if an island has already been spawned
				if biome_id == 12 and !snow_island_spawned:
					generate_cluster(biome_map, cluster_center, biome_id, 32.0, clustering_factor)
					snow_island_spawned = true
				elif biome_id != 12:  # For other biomes, generate normally
					generate_cluster(biome_map, cluster_center, biome_id, 32.0, clustering_factor)

	# Set cells on the grid map
	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			var biome_id = biome_map[x][y]
			if biome_id != -1:
				set_cell_item(Vector3(x, 0, y), biome_id)

# Function to check if a cluster collides with existing clusters of the same or different biome type
func check_cluster_collision(biome_map, cluster_center, clustering_factor, biome_id):
	var cluster_radius = 32.0
	for x in range(int(cluster_center.x - clustering_factor * cluster_radius), int(cluster_center.x + clustering_factor * cluster_radius)):
		for y in range(int(cluster_center.y - clustering_factor * cluster_radius), int(cluster_center.y + clustering_factor * cluster_radius)):
			if x >= 0 and x < int(grid_size.x) and y >= 0 and y < int(grid_size.y):
				if biome_map[x][y] != -1 and biome_map[x][y] != biome_id:
					# Check if the inclusions are touching
					var touching = false
					for dx in range(-1, 2):
						for dy in range(-1, 2):
							var nx = x + dx
							var ny = y + dy
							if nx >= 0 and nx < int(grid_size.x) and ny >= 0 and ny < int(grid_size.y):
								if biome_map[nx][ny] == biome_id:
									touching = true
									break
						if touching:
							break
					if touching:
						return true

					# Check if any adjacent cell is occupied by another biome
					var snow_adjacent = false
					if biome_id == 12 and !snow_island_spawned:
						for nx in range(x - 1, x + 2):
							for ny in range(y - 1, y + 2):
								if nx >= 0 and nx < int(grid_size.x) and ny >= 0 and ny < int(grid_size.y):
									if biome_map[nx][ny] != -1 and biome_map[nx][ny] != 12:  # Not Snow biome
										snow_adjacent = true
										break
							if snow_adjacent:
								break
					if snow_adjacent:
						return true

	return false

# Function to generate a cluster for a given biome
func generate_cluster(biome_map, cluster_center, biome_id, initial_cluster_radius, clustering_factor):
	for y_coord in range(3):  # Adjust the number of Y levels as needed
		var cluster_radius = initial_cluster_radius / (y_coord + 1) / randf_range(1.0, 1.5)  # Decrease the cluster radius as Y level increases
		if y_coord == 0:
			cluster_radius = initial_cluster_radius  # Keep the base cluster radius constant

		if y_coord == 1:  # For the first layer, generate an off-center base
			var offset = Vector2(randf_range(-cluster_radius * 0.6, cluster_radius * 0.6), randf_range(-cluster_radius * 0.6, cluster_radius * 0.6))
			cluster_center += offset

		for x in range(int(cluster_center.x - clustering_factor * cluster_radius), int(cluster_center.x + clustering_factor * cluster_radius)):
			for y in range(int(cluster_center.y - clustering_factor * cluster_radius), int(cluster_center.y + clustering_factor * cluster_radius)):
				if x >= 0 and x < int(grid_size.x) and y >= 0 and y < int(grid_size.y):
					var distance_to_center = cluster_center.distance_to(Vector2(x, y))
					if y_coord == 0:  # Only add inclusion probability for the initial cluster
						var inclusion_probability = 1.0 - (distance_to_center / (clustering_factor * cluster_radius)) * randf_range(0.8, 1.0)
						if inclusion_probability > 0.3 and biome_map[x][y] == -1:
							biome_map[x][y] = biome_id
							set_cell_item(Vector3(x, y_coord, y), biome_id)
					else:
						if distance_to_center <= clustering_factor * cluster_radius and distance_to_center > 0:
							# For the desert biome, randomly choose between Desert_Cube and Desert_Cube_Full
							if biome_id == 2:  # Desert biome
								var tile_type = 2  # Default to Desert_Cube
								if randf() > 0.5:
									tile_type = 1  # Choose Desert_Cube_Full
								biome_map[x][y] = tile_type
								set_cell_item(Vector3(x, y_coord, y), tile_type)
							# For the red biome, randomly choose between Red_Cube and Red_Cube_Full
							if biome_id == 7:  # Red biome
								var tile_type = 6  # Default to Red_Cube
								if randf() > 0.5:
									tile_type = 7  # Choose Red_Cube_Full
								biome_map[x][y] = tile_type
								set_cell_item(Vector3(x, y_coord, y), tile_type)
							# For the Snow Bio
							if biome_id == 12:  # Snow biome
								var tile_type = 11  # Default to Red_Cube
								if randf() > 0.5:
									tile_type = 10  # Choose Red_Cube_Full
								biome_map[x][y] = tile_type
								set_cell_item(Vector3(x, y_coord, y), tile_type)
							# For the Forest Bio
							if biome_id == 20:  # Forest biome
								var tile_type = 20  # Default to Red_Cube
								if randf() > 0.5:
									tile_type = 21  # Choose Red_Cube_Full
								biome_map[x][y] = tile_type
								set_cell_item(Vector3(x, y_coord, y), tile_type)
							else:
								# For other biomes, keep the same tile type as the base biome
								biome_map[x][y] = biome_id
								set_cell_item(Vector3(x, y_coord, y), biome_id)



func spawn_character():
	# Find the Camera node in the scene tree
	var character_body = get_node("../Camera")
	if character_body:
		# Calculate the local position of the grid center relative to the Camera node
		var center_local_position = Vector3(map_center.x * tile_size.x, 10, map_center.y * tile_size.z)
		# Convert the local position to global position
		var center_world_position = self.to_global(center_local_position)
		# Set the character's global position to the calculated position
		character_body.global_transform.origin = center_world_position
