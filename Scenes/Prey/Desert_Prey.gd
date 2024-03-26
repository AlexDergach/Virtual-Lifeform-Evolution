extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
var roam_size = 20.0

var time:float = 0.0

var traits = ["Speed", "Size", "Acceleration", "SensoryRadius", "Self", "Metabolism"]
var size:float = randf_range(3.0,5.0)
var metabolism:float = size / 2.0
var hunger:float = 0.0
var reproduction: float = 1.0  # Initial reproduction value

var hunt = true

var gravity = 9.8
var target_pos:Vector3 = Vector3.ZERO
var stop = false

var food_target = false
var food_location:Vector3 = Vector3.ZERO

var direction = Vector3()
var speed = 2
var accel = 5

var hunger_label: Label
var reproduction_label: Label

func _ready():
	$Timer.start()
	
	hunger_label = Label.new()
	hunger_label.text = "Hunger: " + str(hunger)
	hunger_label.set_position(Vector2(0, -40))  # Adjust position as needed
	add_child(hunger_label)

	# Create and configure reproduction label
	reproduction_label = Label.new()
	reproduction_label.text = "Reproduction: " + str(reproduction)
	reproduction_label.set_position(Vector2(0, -60))  # Adjust position as needed
	add_child(reproduction_label)

	
func _physics_process(delta):
	time += delta
	
	if time >= 1:  # Update target position more frequently
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
		
		time = 0.0
	
	nav.target_position = target_pos

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()
	
	# Update labels
	hunger_label.text = "Hunger: " + str(hunger)
	reproduction_label.text = "Reproduction: " + str(reproduction)

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
