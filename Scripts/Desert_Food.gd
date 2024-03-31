extends Area3D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
	
func _on_area_entered(area):
	if area.is_in_group("desert_prey"):
		queue_free()
