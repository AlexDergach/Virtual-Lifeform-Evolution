extends GridMap

var grid_size = Vector2(50, 50)  # Size of the grid map
var tile_size = Vector3(2, 1, 2)  # Size of each tile

func _ready():
	generate_grid_map()

func generate_grid_map():
	# Iterate over the grid map size
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			# Generate a random number to determine the biome type
			var biome_type = randi() % 2  # 0 for desert, 1 for lava

			# Set the cell item based on the biome type
			match biome_type:
				0:
					if x < 5:  # Create desert biome
						set_cell_item(Vector3(x, 0, y), 2)  # Set tile ID or name according to your mesh library
					else:  # Create lava biome
						set_cell_item(Vector3(x, 0, y), 7)  # Set tile ID or name according to your mesh library

	# Add cacti on the next floor of the desert biome
	for x in range(grid_size.x):
		for y in range(grid_size.y):
			if get_cell_item(Vector3(x, 0, y)) == 2:
				# Generate a random number to determine if a cactus should be placed
				if randf() < 0.1:  # Adjust the probability as needed
					var cactus_position = Vector3(x, 1, y)  # Position cactus on the next floor
					set_cell_item(cactus_position, 3)  # Set cactus tile ID or name according to your mesh library
