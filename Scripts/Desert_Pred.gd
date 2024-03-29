extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var roam_size = 20.0

var time:float = 0.0

var traits = ["Speed", "Size", "Acceleration", "SensoryRadius", "Self", "Metabolism"]
var size:float = 5.0
var metabolism:float = size / 2.0
var hunger:float = 0.0

var prey

var looking:Vector3 = Vector3.ZERO

var hunt = true

var gravity = 9.8
var target_pos:Vector3 = Vector3.ZERO
var stop = false

var food_target = false
var food_location

var direction = Vector3()
var speed = 2
var accel = 5

func _ready():
	$Timer.start()
	pass
	
const TARGET_UPDATE_INTERVAL = 1.0
var time_since_last_target_update = 0.0

func _physics_process(delta):
	
	time_since_last_target_update += delta

	# Update target position less frequently
	if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
		update_target_position()
		time_since_last_target_update = 0.0

	# Calculate direction and velocity
	calculate_movement(delta)
	
func update_target_position():
	if stop:
		target_pos = global_position
		stop = false
	else:
		if _hungry() && food_target:
			target_pos = food_location
			food_target = false
			hunger += 1
			stop = true
		else:
			# Add some randomness to the target position within the roam area
			var random_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			target_pos = global_position + Vector3(random_dir.x * roam_size, 0.1, random_dir.y * roam_size)
			stop = true
	nav.target_position = target_pos

func calculate_movement(delta):
	var test = randi_range(0,1)
	if test == 0:
		direction = nav.get_next_path_position() - global_position
		direction = direction.normalized()
		velocity = velocity.lerp(direction * speed, accel * delta)
		move_and_slide()


func _hungry():
	
	if hunger == -3:
		queue_free()

	if hunger >= metabolism:
		hunt = false
		return false
	else:
		hunt = true		
		return true

func _on_self_area_entered(area):
	pass

func _on_timer_timeout():
	hunger -= 1

func _on_sensory_body_entered(body):
	if body.is_in_group("desert_prey"):
		print("hunting")
		food_target = true
		food_location = body
		
func _on_self_body_entered(body):
	pass # Replace with function body.


func _on_sensory_area_entered(area):
	pass

