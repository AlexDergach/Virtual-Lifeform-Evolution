extends Area3D

#@onready var rabbit = preload("res://Rabbit.tscn")
var rabbit_instance 

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_body_entered(body):
	#bring variable of hunt for that instance of rabit??
	
	if body.is_in_group("herb"):
		queue_free()
