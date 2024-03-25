@tool
extends Node3D

var WaterPlane = preload("res://Scenes/WaterPlane.tscn")
var WaterGrid = preload("res://Resources/WaterGrid.tres")

func createOceanTiles():
	var numTiles = WaterGrid.sP.size()
	for i in range(numTiles):
		# Spawn Loc
		var sL = WaterGrid.sP[i]
		# Tile Subdived
		var tSub = WaterGrid.sD[i]
		# Tile Scale
		var tS = WaterGrid.s[i]

		var instance = WaterPlane.instantiate()
		add_child(instance)
		
		instance.position = Vector3(sL.x, 0.0, sL.y) * 10.05
		instance.mesh.set_subdivide_width(tSub)
		instance.mesh.set_subdivide_depth(tSub)
		instance.scale = Vector3(tS, 1.0, tS)

func _ready():
	# Create Ocean
	createOceanTiles()

func _process(delta):
	# Ocean position in project settings for rendering shaders
	RenderingServer.global_shader_parameter_set("oceanpos", global_transform.origin)
