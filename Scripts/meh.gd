extends GridMap

var grid_size = Vector2(400, 400)  # Size of the grid map
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
		if biome_id == 12 and !snow_island_spawned:
			for i in range(num_clusters):
				var cluster_center = Vector2(randf_range(0.0, grid_size.x), randf_range(0.0, grid_size.y))
				if !check_cluster_collision(biome_map, cluster_center, clustering_factor, biome_id):
					generate_cluster(biome_map, cluster_center, biome_id, 32.0, clustering_factor)
			snow_island_spawned = true  # Set snow_island_spawned to true after generating the snow biome island
		elif biome_id != 12 or (biome_id == 12 and snow_island_spawned):
			for i in range(num_clusters):
				var cluster_center = Vector2(randf_range(0.0, grid_size.x), randf_range(0.0, grid_size.y))
				if !check_cluster_collision(biome_map, cluster_center, clustering_factor, biome_id):
					generate_cluster(biome_map, cluster_center, biome_id, 32.0, clustering_factor)

	# Set cells on the grid map
	for x in range(int(grid_size.x)):
		for y in range(int(grid_size.y)):
			var biome_id = biome_map[x][y]
			if biome_id != -1:
				set_cell_item(Vector3(x, 0, y), biome_id)
	spawn_cacti_and_palm_trees()
	spawn_red_biome_assets()
	spawn_snow_biome_assets()
	spawn_stone_biome_assets()
	spawn_forest_biome_assets()

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

func generate_cluster(biome_map, cluster_center, biome_id, initial_cluster_radius, clustering_factor):
	var cluster_radii = []  # Declare cluster_radii as an empty list
	var final_cluster_radius
	for y_coord in range(3):  # Adjust the number of Y levels as needed
		var cluster_radius = initial_cluster_radius / (y_coord + 1) / randf_range(1.0, 1.5)  # Decrease the cluster radius as Y level increases
		if y_coord == 0:
			cluster_radius = initial_cluster_radius  # Keep the base cluster radius constant

		if y_coord == 1:  # For the first layer, generate an off-center base
			var offset = Vector2(randf_range(-cluster_radius * 0.6, cluster_radius * 0.6), randf_range(-cluster_radius * 0.6, cluster_radius * 0.6))
			cluster_center += offset

		final_cluster_radius = cluster_radius  # Store the final base cluster radius size for this cluster
		cluster_radii.append(final_cluster_radius)  # Append the final cluster radius to the list

		#print("Final Cluster Radius Size for Y =", y_coord, ":", final_cluster_radius)  # Print the final cluster radius size for each Y level

		for x in range(int(cluster_center.x - clustering_factor * final_cluster_radius), int(cluster_center.x + clustering_factor * final_cluster_radius)):
			for y in range(int(cluster_center.y - clustering_factor * final_cluster_radius), int(cluster_center.y + clustering_factor * final_cluster_radius)):
				if x >= 0 and x < int(grid_size.x) and y >= 0 and y < int(grid_size.y):
					var distance_to_center = cluster_center.distance_to(Vector2(x, y))
					if y_coord == 0:  # Only add inclusion probability for the initial cluster
						var inclusion_probability = 1.0 - (distance_to_center / (clustering_factor * final_cluster_radius)) * randf_range(0.8, 1.0)
						if inclusion_probability > 0.3 and biome_map[x][y] == -1:
							biome_map[x][y] = biome_id
							set_cell_item(Vector3(x, y_coord, y), biome_id)
					else:
						var tile_type  # Declare tile_type here
						if distance_to_center <= clustering_factor * final_cluster_radius and distance_to_center > 0:
							# Assign tile types based on biome ID
							match biome_id:
								2:  # Desert biome
									tile_type = 2 if randf() > 0.5 else 1  # Randomly choose between Desert_Cube and Desert_Cube_Full
								7:  # Red biome
									tile_type = 7 if randf() > 0.5 else 6  # Randomly choose between Red_Cube_Full and Red_Cube
								12:  # Snow biome
									tile_type = 10 if randf() > 0.5 else 11  # Randomly choose between Red_Cube_Full and Red_Cube
								20:  # Forest biome
									tile_type = 21 if randf() > 0.5 else 20  # Randomly choose between Red_Cube_Full and Red_Cube
								_:  # Default case
									tile_type = biome_id  # Use biome ID as tile type
								
							biome_map[x][y] = tile_type
							set_cell_item(Vector3(x, y_coord, y), tile_type)
							
func spawn_cacti_and_palm_trees():
	var random_asset_id
	for x in range(int(grid_size.x)):
		for z in range(int(grid_size.y)):
			# Check if the current cell is on the ground floor (y=0) and empty
			if get_cell_item(Vector3(x, 0, z)) == 2 and get_cell_item(Vector3(x, 1, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a cactus (ID 0), a palm tree (ID 3), or a pyramid (ID 4)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 1, z), 0)  # Spawn cactus (ID 0) at y=1
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 1, z), 3)  # Spawn palm tree (ID 3) at y=1
					else:
						# Spawn additional smaller pyramids nearby
						if randf() < 0.025:
							set_cell_item(Vector3(x, 1.5, z), 4)
			
			# Check if the current cell is on the hill layer (y=1) and empty
			if get_cell_item(Vector3(x, 1, z)) in [1, 2] and get_cell_item(Vector3(x, 2, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a cactus (ID 0), a palm tree (ID 3), or a pyramid (ID 4)
					random_asset_id = randi_range(0, 1)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 2, z), 0)  # Spawn cactus (ID 0) at y=2
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 2, z), 3)  # Spawn palm tree (ID 3) at y=2
			
			# Check if the current cell is on the hill layer (y=2) and empty
			if get_cell_item(Vector3(x, 2, z)) in [1, 2] and get_cell_item(Vector3(x, 3, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a cactus (ID 0), a palm tree (ID 3), or a pyramid (ID 4)
					random_asset_id = randi_range(0, 1)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 3, z), 0)  # Spawn cactus (ID 0) at y=3
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 3, z), 3)  # Spawn palm tree (ID 3) at y=3

func spawn_red_biome_assets():
	var random_asset_id
	for x in range(int(grid_size.x)):
		for z in range(int(grid_size.y)):
			# Check if the current cell is on the ground floor (y=0) of the red biome and empty
			if get_cell_item(Vector3(x, 0, z)) in [6, 7] and get_cell_item(Vector3(x, 1, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a spike (ID 5), a red spike (ID 8), or a red tree (ID 9)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 1, z), 5)  # Spawn spike (ID 5) at y=1
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 1, z), 8)  # Spawn red spike (ID 8) at y=1
					else:
						set_cell_item(Vector3(x, 1, z), 9)  # Spawn red tree (ID 9) at y=1
			
			# Check if the current cell is on the hill layer (y=1) of the red biome and empty
			if get_cell_item(Vector3(x, 1, z)) in [6, 7] and get_cell_item(Vector3(x, 2, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a spike (ID 5), a red spike (ID 8), or a red tree (ID 9)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 2, z), 5)  # Spawn spike (ID 5) at y=2
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 2, z), 8)  # Spawn red spike (ID 8) at y=2
					else:
						set_cell_item(Vector3(x, 2, z), 9)  # Spawn red tree (ID 9) at y=2
						
			# Check if the current cell is on the hill layer (y=2) of the red biome and empty
			if get_cell_item(Vector3(x, 2, z)) in [6, 7] and get_cell_item(Vector3(x, 3, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a spike (ID 5), a red spike (ID 8), or a red tree (ID 9)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 3, z), 5)  # Spawn spike (ID 5) at y=3
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 3, z), 8)  # Spawn red spike (ID 8) at y=3
					else:
						set_cell_item(Vector3(x, 3, z), 9)  # Spawn red tree (ID 9) at y=3

func spawn_snow_biome_assets():
	var random_asset_id
	for x in range(int(grid_size.x)):
		for z in range(int(grid_size.y)):
			# Check if the current cell is on the ground floor (y=0) of the snow biome and empty
			if get_cell_item(Vector3(x, 0, z)) in [10, 11, 12] and get_cell_item(Vector3(x, 1, z)) == -1:
				if randf() < 0.2:
					# Randomly choose between spawning a snowman (ID 13) or a snowflake (ID 14)
					random_asset_id = randi_range(0, 1)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 1, z), 13)  # Spawn snowman (ID 13) at y=1
					else:
						if randf() < 0.5:
							set_cell_item(Vector3(x, 1, z), 14)  # Spawn snowflake (ID 14) at y=1
			
			# Check if the current cell is on the hill layer (y=1) of the snow biome and empty
			if get_cell_item(Vector3(x, 1, z)) in [10, 11, 12] and get_cell_item(Vector3(x, 2, z)) == -1:
				if randf() < 0.2:
					set_cell_item(Vector3(x, 2, z), 14)  # Spawn snowflake (ID 14) at y=2
						
			# Check if the current cell is on the hill layer (y=2) of the snow biome and empty
			if get_cell_item(Vector3(x, 2, z)) in [10, 11, 12] and get_cell_item(Vector3(x, 3, z)) == -1:
				if randf() < 0.2:
					set_cell_item(Vector3(x, 3, z), 14)  # Spawn snowflake (ID 14) at y=3

func spawn_stone_biome_assets():
	var random_asset_id
	for x in range(int(grid_size.x)):
		for z in range(int(grid_size.y)):
			# Check if the current cell is on the ground floor (y=0) of the stone biome and empty
			if get_cell_item(Vector3(x, 0, z)) == 18 and get_cell_item(Vector3(x, 1, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a skull (ID 17), a mountain (ID 16), or a big stone (ID 15)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 1, z), 17)  # Spawn skull (ID 17) at y=1
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 1, z), 16)  # Spawn mountain (ID 16) at y=1
					else:
						set_cell_item(Vector3(x, 1, z), 15)  # Spawn big stone (ID 15) at y=1
			
			# Check if the current cell is on the hill layer (y=1) of the stone biome and empty
			if get_cell_item(Vector3(x, 1, z)) == 18 and get_cell_item(Vector3(x, 2, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a skull (ID 17), a mountain (ID 16), or a big stone (ID 15)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 2, z), 17)  # Spawn skull (ID 17) at y=2
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 2, z), 16)  # Spawn mountain (ID 16) at y=2
					else:
						set_cell_item(Vector3(x, 2, z), 15)  # Spawn big stone (ID 15) at y=2
						
			# Check if the current cell is on the hill layer (y=2) of the stone biome and empty
			if get_cell_item(Vector3(x, 2, z)) == 18 and get_cell_item(Vector3(x, 3, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a skull (ID 17), a mountain (ID 16), or a big stone (ID 15)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 3, z), 17)  # Spawn skull (ID 17) at y=3
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 3, z), 16)  # Spawn mountain (ID 16) at y=3
					else:
						set_cell_item(Vector3(x, 3, z), 15)  # Spawn big stone (ID 15) at y=3

func spawn_forest_biome_assets():
	var random_asset_id
	for x in range(int(grid_size.x)):
		for z in range(int(grid_size.y)):
			# Check if the current cell is on the ground floor (y=0) of the forest biome and empty
			if get_cell_item(Vector3(x, 0, z)) == 20 and get_cell_item(Vector3(x, 1, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a birch tree (ID 19), a forest tree (ID 22), or a stump (ID 23)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 1, z), 19)  # Spawn birch tree (ID 19) at y=1
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 1, z), 22)  # Spawn forest tree (ID 22) at y=1
					else:
						set_cell_item(Vector3(x, 1, z), 23)  # Spawn stump (ID 23) at y=1
			
			# Check if the current cell is on the hill layer (y=1) of the forest biome and empty
			if get_cell_item(Vector3(x, 1, z)) == 20 and get_cell_item(Vector3(x, 2, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a birch tree (ID 19), a forest tree (ID 22), or a stump (ID 23)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 2, z), 19)  # Spawn birch tree (ID 19) at y=2
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 2, z), 22)  # Spawn forest tree (ID 22) at y=2
					else:
						set_cell_item(Vector3(x, 2, z), 23)  # Spawn stump (ID 23) at y=2
						
			# Check if the current cell is on the hill layer (y=2) of the forest biome and empty
			if get_cell_item(Vector3(x, 2, z)) == 20 and get_cell_item(Vector3(x, 3, z)) == -1:
				if randf() < 0.025:
					# Randomly choose between spawning a birch tree (ID 19), a forest tree (ID 22), or a stump (ID 23)
					random_asset_id = randi_range(0, 2)
					if random_asset_id == 0:
						set_cell_item(Vector3(x, 3, z), 19)  # Spawn birch tree (ID 19) at y=3
					elif random_asset_id == 1:
						set_cell_item(Vector3(x, 3, z), 22)  # Spawn forest tree (ID 22) at y=3
					else:
						set_cell_item(Vector3(x, 3, z), 23)  # Spawn stump (ID 23) at y=3

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
