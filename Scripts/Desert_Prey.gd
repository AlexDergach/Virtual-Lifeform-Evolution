extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var progress_bar = $SubViewport/Hunger
@onready var progress_bar2 = $SubViewport/Repo
@onready var progress_bar3 = $SubViewport/Gender

@onready var progress_bar_text = $SubViewport/RichTextLabel
@onready var progress_bar_text2 = $SubViewport/RichTextLabel2
@onready var progress_bar_text3 = $SubViewport/RichTextLabel3



var roam_size = 20.0
var rotation_speed = 5.0
var should_take_break
var escape_directions = []

var time:float = 0.0

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

var hunger_label: Label3D
var reproduction_label: Label3D
var time_since_last_target_update = 0.0

# Variables for child tracking
var is_child = false
var child_timer = 0.0
var child_duration = 10.0 
var child_speed_factor = 0.75
var child_scale_factor = 0.25

var is_female = false  # Default to false


func _ready():
	
	$Timer.start()

	

	if is_child:
		# If this instance is a child, start the timer for transitioning parameters
		$Child_Timer.start()
		# Scale down the size
		#size *= child_scale_factor
		self.scale = Vector3(size,size,size)
		inital_speed = speed
		# Do hunger
	else:
		# If it's not a child (i.e., an adult), initialize random size, speed, and hunger capacity
		size = randf_range(1.0, 2.0)
		self.scale = Vector3(size,size,size)
		accel = randi_range(3.0, 5.0)
		speed = randi_range(1.0, 3.0)  # Adjust as needed
		inital_speed = speed
		hunger = randi_range(6.0, 12.0)  # Adjust as needed
		metabolism = size / 2
		is_female = randf() < 1.0 / 3.0   # Randomly assign true (female) or false (male)
		
		print(" Size: ", size , " Accel: ", accel," Speed: ",speed, " Hunger: ", 
		hunger, " Meta: ", metabolism, " Female: ", is_female)

		
	progress_bar.min_value = 0
	progress_bar2.max_value = 1
	progress_bar2.min_value = 0
	progress_bar3.value = progress_bar3.max_value
	
	if is_female:
		print("Female")
		var desired_color = Color(1.0, 0.75, 0.8) # Red color
		progress_bar3.modulate = desired_color
		progress_bar_text3.text = "Female"
		
	else:
		print("Male")
		
		var desired_color = Color(0.5, 0.5, 1.0) # Red color
		progress_bar3.modulate = desired_color
		progress_bar_text3.text = "Male"


func _process(delta):
	
	progress_bar.max_value = hunger
			
	if hunger == 0:
		queue_free()
	
	if progress_bar.value > 0:
		progress_bar.value = hunger
		progress_bar_text.text = "Food : " + str(hunger)
		
	if hunger > 0.0:
		reproduction = 1
	else: 
		reproduction = 0
			
	if reproduction == 1:
		progress_bar2.value = reproduction
		progress_bar_text2.text = "Looking For Mate"
	else:
		progress_bar2.value = reproduction
		progress_bar_text2.text = " "
	
	
		


func _physics_process(delta):
	
	# Calculate the direction to the target
	var target_direction = nav.target_position - global_position
	target_direction.y = 0  # Ignore vertical component for 2D rotation
	
	# Calculate the angle between the forward vector and the target direction
	var target_rotation = atan2(target_direction.x, target_direction.z)
	
	# Adjust rotation speed based on proximity to target rotation
	var rotation_speed_adjusted = rotation_speed * 0.5
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

	if hunger >= 2:
		return false
	else:
		return true

func _on_timer_timeout():
	hunger -= 1
	
var enemy = null
var mating_partner = null
var mating_partner_1 = null
var mating_partner_2 = null
var has_mated = false
var first_mate_size
var first_mate_hunger
var partners = 0
var mate_chosen = 1

func _on_sensory_area_entered(area):
	
	if area.is_in_group("desert_food") && _hungry():
		#print("Prey : Food spotted")
		food_target = true
		target_pos = area.global_position
		nav.target_position = target_pos
		
	if area.is_in_group("desert_pred"):
		enemy = area
		$StateChart.send_event("enemy_entered")
		time_since_last_target_update = randf_range(1.0, 10.0)  # Start running immediately
		
	if is_female:		
		if area.is_in_group("desert_prey") and !has_mated and !area.get_parent().is_female:
			
			if mating_partner_1 == null:
				print("Partner 1 spotted")
				mating_partner_1 = area
				# Save the stats of the first encountered mate
				first_mate_size = mating_partner_1.get_parent().size
				first_mate_hunger = mating_partner_1.get_parent().hunger
				print("Average Score 1: ", first_mate_size + first_mate_hunger)
				partners += 1
			elif mating_partner_2 == null and area != mating_partner_1:
				print("Partner 2 spotted")
				mating_partner_2 = area
				# Compare stats with the second mate
				var second_mate_size = area.get_parent().size
				var second_mate_hunger = area.get_parent().hunger
				print("Average Score 2: ", second_mate_size + second_mate_hunger)
				
				if second_mate_size + second_mate_hunger > first_mate_size + first_mate_hunger:
					# Second mate is better, mate with it
					mating_partner_2 = area
					first_mate_size = second_mate_size
					first_mate_hunger = second_mate_hunger
					mate_chosen = 2
				# else: Stick with the first mate
				partners += 1
				
			if partners == 2:
				print("Mating with : ", mate_chosen)

func _on_self_area_entered(area):
	if area.is_in_group("desert_pred"):
		#print("Dead")
		queue_free()
	#If food enters self area, it gets eaten
	if area.is_in_group("desert_food"):
		food_target = false
		hunger += 1
		#print("Prey: Food ate")
	if area.is_in_group("desert_prey") and partners == 2 and area == mating_partner:
		print("Mate: ", mate_chosen, " Touched Sending Repo State")
		$StateChart.send_event("repo")
	

#If Pred Leaves The Sensory Area
func _on_sensory_area_exited(area):
	if area.is_in_group("desert_pred"):
		$StateChart.send_event("enemy_exited")

func _on_wandering_state_entered():
	var num_escape_directions = 3
	# Clear previous escape directions
	escape_directions.clear()
	# Calculate multiple escape directions
	for i in range(num_escape_directions):
		var random_dir = Vector3(randf_range(-1.0, 1.0), 0.1, randf_range(-1.0, 1.0)).normalized()
		escape_directions.append(random_dir)
	enemy = null

func _on_running_state_processing(delta):
	# Check if it's time to update escape direction
	if time_since_last_target_update >= randf_range(1.0, 10.0):
		#print("Running")
		# Calculate the direction away from the enemy
		var direction_to_enemy = global_position - enemy.global_position
		direction_to_enemy.y = 0  # Ignore vertical component
		
		# Normalize the direction
		direction_to_enemy = direction_to_enemy.normalized()
		
		# Calculate the new target position by adding the normalized direction away from the predator
		# to the prey's current position
		var new_target_position = global_position + direction_to_enemy * 10  # Adjust the multiplier as needed
		
		# Set the navigation target to the new target position
		nav.target_position = new_target_position
		
		# Reset the timer
		time_since_last_target_update = 0.0



func _on_wandering_state_processing(delta):
	var TARGET_UPDATE_INTERVAL = randf_range(4.0, 10.0)
	time_since_last_target_update += delta
	
	if partners != 2:
		if food_target == false:
			# Continue wandering
			if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
				
				var random_dir = Vector3(randf_range(-0.5, 0.5), 0.1, randf_range(-0.5, 0.5)).normalized()
				target_pos = global_position + Vector3(random_dir.x * roam_size, 0.1, random_dir.z * roam_size)
				nav.target_position = target_pos
				time_since_last_target_update = 0.0
				
			# Check if the creature has reached its target position
			if global_position.distance_to(nav.target_position) < 1.0: 
				time_since_last_target_update = 20.0  # Reset the timer to find a new target position
	else: 
			if mate_chosen == 1:
				print("Going to one")
				mating_partner = mating_partner_1
				nav.target_position = mating_partner_1.global_position
			else: 
				print("Going to two")
				mating_partner = mating_partner_2
				nav.target_position = mating_partner_2.global_position
	

func _on_repo_state_entered():
	# Reproduction state entered
	if mating_partner != null:
		print("In Repo state")
		# Mate with the partner
		has_mated = true
		var avg_size = (size + mating_partner.get_parent().size) / 2.0
		var avg_speed = (inital_speed + mating_partner.get_parent().inital_speed) / 2.0
		var avg_accel = (accel + mating_partner.get_parent().accel) / 2.0
		create_child(avg_size,avg_speed,avg_accel)
		# Reset mating_partner for future reproduction
		mating_partner = null
		$StateChart.send_event("repo_done")


func create_child(size,speed,accel):
	print("Creatign Child")
	# Create a new instance of the same creature as a child
	var child = load("res://Scenes/Prey/Desert_Prey.tscn").instantiate()
	# Initialize child variables
	child.size = size * child_scale_factor
	child.speed = speed * child_scale_factor
	child.accel = accel * child_scale_factor
	#set speed
	child.is_child = true  # Mark the child as a child
	# Position the child nearby the parent
	child.global_position = global_position + Vector3(randi_range(-1, 1), 0, randi_range(-1, 1))
	# Add the child to the scene or appropriate container
	get_parent().add_child(child)

func _on_child_timer_timeout():
	is_child = false
	size /= child_scale_factor
	speed /= child_speed_factor


func _on_repo_state_processing(delta):
	pass # Replace with function body.
