extends CharacterBody3D

@onready var navigation_region: NavigationRegion3D = get_node("/root/MainMap/NavigationRegion3D")
#@onready var navigation_region: NavigationRegion3D = get_node("/root/Terrian/NavigationRegion3D")

@onready var nav: NavigationAgent3D = $NavigationAgent3D

var generation = 0

var TARGET_UPDATE_INTERVAL = randf_range(4.0, 10.0)

var roam_size = 20.0
var rotation_speed = 5.0
var should_take_break
var escape_directions = []

var time:float = 0.0

var polygon_vertices

var metabolism
var size
var hunger
var reproduction = 1

var hunt = true
var done
var gravity = 9.8
var target_pos:Vector3 = Vector3.ZERO
var stop = true

var food_target = false
var food_location:Vector3 = Vector3.ZERO

var direction = Vector3()
var accel
var speed
var inital_speed
var inital_hunger

var hunger_label: Label3D
var reproduction_label: Label3D
var time_since_last_target_update = 0.0

# Variables for child tracking
var is_child = false
var child_timer = 0.0
var child_duration = 10.0 
var child_factor = 0.75
var child_scale_factor = 0.25

var is_female = false

var speed_counter = 0
var hunger_half

var mother = null


func _ready():
	
	var lifespan = randi_range(60,100)
	
	
	time_since_last_target_update = TARGET_UPDATE_INTERVAL
	size = randf_range(0.4, 0.8)
	self.scale = Vector3(size,size,size)
	accel = randf_range(3.0, 5.0)
	speed = randf_range(1.0, 3.0)
	inital_speed = speed
	hunger = randi_range(6, 12)
	inital_hunger = hunger
	metabolism = size / 2
	is_female = randf() < 1.0 / 3.0   # Randomly assign true (female) or false (male)
	var a = (size + accel + inital_speed + inital_hunger + metabolism) / 5
		#print(" Size: ", size , " Accel: ", accel," Speed: ",inital_speed, " Hunger: ", inital_hunger, " Meta: ", metabolism, " Female: ", is_female, " Average: ", a)
	
	hunger_half = floor(inital_hunger/2)
	
func _process(_delta):
	
	if Input.is_action_just_pressed("SpeedUp"):
		if speed_counter == 0:
			speed_counter += 1
			speed = inital_speed
			speed *= 2
		elif speed_counter == 1:
			speed_counter += 1
			speed = inital_speed
			speed *= 3
		elif speed_counter == 2:
			speed_counter += 1
			speed = inital_speed
			speed *= 4
			
	if Input.is_action_just_pressed("SpeedDown"):
		if speed_counter == 1:
			speed_counter -= 1
			speed = inital_speed
		elif speed_counter == 2:
			speed_counter -= 1
			speed = inital_speed
			speed *= 2
		elif speed_counter == 3:
			speed_counter -= 1
			speed = inital_speed
			speed *= 3
			
	if hunger == 0:
		queue_free()
		
	if hunger > hunger_half:
		reproduction = 1
	else: 
		reproduction = 0

func _physics_process(delta):
	
	if is_child and mother != null:
		nav.target_position = mother.global_position

		rotation = Vector3(0,rotation.y,0)
		
	time = delta
	

func update_target_location(target_location):
	get_node("NavigationAgent3D").set_target_position(target_location)
	

func calculate_movement(delta):

	var current_location = global_position
	var next_location = get_node("NavigationAgent3D").get_next_path_position()
	var new_velocity = (next_location - current_location).normalized() * speed
	
	velocity = new_velocity
	move_and_slide()

func _hungry():
	
	if hunger >= hunger_half:
		return false
	else:
		return true

func _on_timer_timeout():
	hunger -= 1
	
