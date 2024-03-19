extends GridMap

var grid_size = Vector2(300, 300)  # Size of the grid map
var tile_size = Vector3(2, 1, 2)  # Size of each tile
var map_center = grid_size / 2  # Center of the grid map
var character_body = null

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
			generate_cluster(biome_map, cluster_center, biome_id, 30.0, clustering_factor)  # Decrease hill radius to 30.0

	# Set cells on the grid map
	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			var biome_id = biome_map[x][y]
			if biome_id != -1:
				set_cell_item(Vector3(x, 0, y), biome_id)

# Function to generate a cluster for a given biome
func generate_cluster(biome_map, cluster_center, biome_id, initial_cluster_radius, clustering_factor):
	for y_coord in range(3):  # Adjust the number of Y levels as needed
		var cluster_radius = initial_cluster_radius / (y_coord + 1)  # Decrease the cluster radius as Y level increases

		for x in range(int(cluster_center.x - clustering_factor * cluster_radius), int(cluster_center.x + clustering_factor * cluster_radius)):
			for y in range(int(cluster_center.y - clustering_factor * cluster_radius), int(cluster_center.y + clustering_factor * cluster_radius)):
				if x >= 0 and x < int(grid_size.x) and y >= 0 and y < int(grid_size.y):
					var distance_to_center = cluster_center.distance_to(Vector2(x, y))
					if distance_to_center <= clustering_factor * cluster_radius:
						biome_map[x][y] = biome_id
						set_cell_item(Vector3(x, y_coord, y), biome_id)  # Set the Y coordinate of the cell item

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
