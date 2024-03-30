extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var progress_bar = $SubViewport/Hunger
@onready var progress_bar2 = $SubViewport/Repo
@onready var progress_bar_text = $SubViewport/RichTextLabel
@onready var progress_bar_text2 = $SubViewport/RichTextLabel2

var roam_size = 20.0
var rotation_speed = 5.0
var should_take_break

var time:float = 0.0

var traits = ["Speed", "Size", "Acceleration", "SensoryRadius", "Self", "Metabolism"]
var size:float = randf_range(3.0,5.0)
var metabolism:float = size / 2.0
var hunger:float = 3.0
var reproduction: float = 1.0  # Initial reproduction value

var hunt = true
var done
var gravity = 9.8
var target_pos:Vector3 = Vector3.ZERO
var stop = true

var food_target = false
var food_location:Vector3 = Vector3.ZERO


var direction = Vector3()
var speed = 2
var accel = 5

var hunger_label: Label3D
var reproduction_label: Label3D
var time_since_last_target_update = 0.0


func _ready():
	
	$Timer.start()

func _process(delta):
	
	progress_bar.max_value = 3
	progress_bar.min_value = -3
	progress_bar2.max_value = 1
	progress_bar2.min_value = 0
	
	
	if progress_bar.value > -4:
		progress_bar.value = hunger
		progress_bar_text.text = "Food : " + str(hunger)
			
	if reproduction == 1:
		progress_bar2.value = reproduction
		progress_bar_text2.text = "Looking For Mate"
	else:
		progress_bar2.value = reproduction
		progress_bar_text2.text = " "
		
	if hunger > 0.0:
		reproduction = 1
	else: 
		reproduction = 0

func _physics_process(delta):
	
	# Calculate the direction to the target
	var target_direction = nav.target_position - global_position
	target_direction.y = 0  # Ignore vertical component for 2D rotation
	
	# Calculate the angle between the forward vector and the target direction
	var target_rotation = atan2(target_direction.x, target_direction.z)
	
	# Adjust rotation speed based on proximity to target rotation
	var rotation_speed_adjusted = rotation_speed
	if abs(rotation.y - target_rotation) < 0.1:
		rotation_speed_adjusted *= 0.5
	
	# Smoothly rotate towards the target rotation
	rotation.y = lerp(rotation.y, target_rotation, rotation_speed_adjusted * delta)
		
	time = delta
	
	calculate_movement(delta)

func calculate_movement(delta):
	
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

func _on_timer_timeout():
	hunger -= 1
	
var prey = null

func _on_sensory_area_entered(area):
	#print("In this area")
	#print(_hungry())
	if area.is_in_group("stone_prey") && _hungry():
		#print("Pred: Prey spotted")
		food_target = true
		prey = area
		$StateChart.send_event("prey_entered")

func _on_self_area_entered(area):
	#If food enters self area, it gets eaten
	if area.is_in_group("stone_prey"):
		food_target = false
		hunger += 1
		#print("Pred: Food ate")
		prey = null

#If Pred Leaves The Sensory Area

func _on_sensory_area_exited(area):
	if area.is_in_group("stone_prey"):
		#print("Prey left")
		$StateChart.send_event("prey_exited")

func _on_wandering_state_entered():
	pass

func _on_wandering_state_processing(delta):
	var TARGET_UPDATE_INTERVAL = randf_range(4.0, 12.0)
	time_since_last_target_update += delta
	
	if food_target == false:
		# Continue wandering
		if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
			var random_dir = Vector3(randf_range(-0.5, 0.5), 0.1, randf_range(-0.5, 0.5)).normalized()
			target_pos = global_position + Vector3(random_dir.x * roam_size, 0.1, random_dir.z * roam_size)
			nav.target_position = target_pos
			time_since_last_target_update = 0.0


func _on_hunting_state_processing(delta):
	target_pos = prey.global_position
	nav.target_position = target_pos
