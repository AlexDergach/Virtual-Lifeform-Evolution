@tool

extends Node3D

var WaterPlane = preload("res://Scenes/WaterPlane.tscn");
var waterGrid = preload("res://Resources/WaterGrid.tres");

func createOceanTiles():
	for i in 17: # 17 tiles in arrays for waterGird
		
		#Spawn Loc
		var sL = waterGrid.sP[i];
		# Tile Sub division
		var tSub = waterGrid.sD[i];
		# Scale
		var tS = waterGrid.s[i];
		
		var instance = WaterPlane.instantiate();
		
		add_child(instance);
		
		# Set pos scale and subs for the instantces
		instance.position = Vector3(sL.x,0.0,sL.y) * 10.05; #Water plane size multiple (10.05)
		instance.mesh.set_subdivide_width(tSub);
		instance.mesh.set_subdivide_depth(tSub);
		instance.set_scale(Vector3(tS, 1.0, tS));

func _ready():
	#Create ocean
	createOceanTiles();

func _process(delta):
	#oceanpos in project seetings for rendering sharders
	RenderingServer.global_shader_parameter_set("oceanpos", self.position);
