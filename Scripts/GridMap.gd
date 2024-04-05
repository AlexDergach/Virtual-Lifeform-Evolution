extends GridMap

func _ready():
	if mesh_library:
		for x in range(get_used_cells().size()):
			for y in range(get_used_cells().size()):
				var cell = Vector3(x, 0, y)
				var item_id = get_cell_item(cell)
				if item_id != -1:
					var tile_name = mesh_library.get_item_name(item_id)
					if item_id == 2:
						generate_navigation_region_for_desert(cell)
						print(mesh_library.get_item_name(item_id))
					elif item_id == 20:
						generate_navigation_region_for_forest(cell)
						print(mesh_library.get_item_name(item_id))
						
	else:
		print("No mesh library assigned to the GridMap node.")

func generate_navigation_region_for_desert(cell):
	var navigation_instance = get_node("/root/MapTest/NavigationRegion3D")
	navigation_instance.transform.origin = Vector3(cell.x, 0, cell.z)
	navigation_instance.bake_navigation_mesh()

func generate_navigation_region_for_forest(cell):
	var navigation_instance = get_node("/root/MapTest/NavigationRegion3D")
	navigation_instance.transform.origin = Vector3(cell.x, 0, cell.z)
	navigation_instance.bake_navigation_mesh()
