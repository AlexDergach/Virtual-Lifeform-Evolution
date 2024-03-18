extends GridMap

func _ready():
	# Ensure that the GridMap has a mesh library assigned
	if mesh_library:
		# Iterate over all cells in the grid map
		for x in range(get_used_cells().size()):
			for y in range(get_used_cells().size()):
				var cell = Vector3(x, 0, y) # Ensure Y is 0 for ground level
				# Get the item ID at the cell
				var item_id = get_cell_item(cell)
				if item_id != -1:
					# Get the tile name associated with the item ID
					var tile_name = mesh_library.get_item_name(item_id)
					print("Tile name in cell ", cell, " is: ", tile_name)
	else:
		print("No mesh library assigned to the GridMap node.")
