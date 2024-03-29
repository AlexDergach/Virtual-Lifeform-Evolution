extends Node3D

var food_scene = load("res://Scenes/Food/Desert_Food.tscn")
var desert_prey = load("res://Scenes/Prey/Desert_Prey.tscn")
var fire_prey = load("res://Scenes/Pred/Desert_Pred.tscn")
var rabbit = load("res://Scenes/Prey/Rabbit.tscn")


var food_size = 0.5
var rabbit_size = 1
var spawn_rate = 1
var rabbit_instance
var enemy_instance

@onready var map_size = get_node("NavigationRegion3D/CSGBox3D").get_scale()
#@onready var map_height = get_node("NavigationRegion3D/CSGBox3D")

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	
	$Timer.start()
	
	pass
	

func _spawn_food():
	var food_instance = food_scene.instantiate()
	var food_instance_scale = Vector3(food_size,food_size,food_size)
	food_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	food_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	food_instance.position.y = map_size.y + food_size/2
	add_child(food_instance)
	#print(map_height)
	food_instance.scale = food_instance_scale

func _spawn_rabbit():
	rabbit_instance = desert_prey.instantiate()
	var rabbit_instance_scale = Vector3(rabbit_size,rabbit_size,rabbit_size)
	#fix the y position to work with tilts
	rabbit_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	rabbit_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	rabbit_instance.position.y = map_size.y + 1
	add_child(rabbit_instance)

	rabbit_instance.scale = rabbit_instance_scale
	
func _spawn_rabbit2():
	rabbit_instance = rabbit.instantiate()
	var rabbit_instance_scale = Vector3(rabbit_size,rabbit_size,rabbit_size)
	#fix the y position to work with tilts
	rabbit_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	rabbit_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	rabbit_instance.position.y = map_size.y
	add_child(rabbit_instance)

	rabbit_instance.scale = rabbit_instance_scale

func _spawn_enemy():
	enemy_instance = fire_prey.instantiate()
	var enemy_instance_scale = Vector3(rabbit_size,rabbit_size,rabbit_size)
	#fix the y position to work with tilts
	enemy_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	enemy_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	enemy_instance.position.y = 0.1
	
	add_child(enemy_instance)

	enemy_instance.scale = enemy_instance_scale

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	
	if spawn_rate == 1:
		_spawn_rabbit()
		
		
		spawn_rate = 0
		
	if Input.is_action_just_pressed("Test"):
		_spawn_food()
	
	if Input.is_action_just_pressed("Exit"):
		get_tree().quit()


func _on_timer_timeout():
	_spawn_food()

