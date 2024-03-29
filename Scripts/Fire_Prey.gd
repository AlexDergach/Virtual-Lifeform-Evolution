extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var roam_size = 20.0

var time:float = 0.0

var traits = ["Speed", "Size", "Acceleration", "SensoryRadius", "Self", "Metabolism"]
var size:float = randf_range(3.0,5.0)
var metabolism:float = size / 2.0
var hunger:float = 0.0

var hunt = true

var gravity = 9.8
var target_pos:Vector3 = Vector3.ZERO
var stop = false

var food_target = false
var food_location:Vector3 = Vector3.ZERO

var direction = Vector3()
var speed = 2
var accel = 5

func _ready():
	$Timer.start()
	pass
	
const TARGET_UPDATE_INTERVAL = 1.0
var time_since_last_target_update = 0.0

	
var rotation_speed = 5.0	
func _physics_process(delta):
	
	time_since_last_target_update += delta

	# Update target position less frequently
	if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
		update_target_position()
		time_since_last_target_update = 0.0

	if velocity.length_squared() > 0.01:  # Ensure the creature is moving
		var target_rotation = atan2(velocity.x, velocity.z)

		# Smooth out rotation speed when close to target rotation
		var rotation_speed_adjusted = rotation_speed
		if abs(rotation.y - target_rotation) < 0.1:
			rotation_speed_adjusted *= 0.5

		rotation.y = lerp(rotation.y, target_rotation, rotation_speed_adjusted * delta)
	else:
		# If the creature is not moving, keep its rotation stable
		rotation.y = 0

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
	
	if hunger == -10:
		queue_free()

	if hunger >= metabolism:
		hunt = false
		return false
	else:
		hunt = true		
		return true

func _on_timer_timeout():
	hunger -= 1

func _on_sensory_area_entered(area):
	if area.is_in_group("food"):
		food_target = true
		food_location = area.global_position


func _on_self_body_entered(body):
	if body.is_in_group("pred"):
		print("here")
		queue_free()
