extends CharacterBody3D

@onready var navigation_region: NavigationRegion3D = get_node("/root/MainMap/NavigationRegion3D")
#@onready var navigation_region: NavigationRegion3D = get_node("/root/Terrian/NavigationRegion3D") # <- For Testing Map

@onready var nav: NavigationAgent3D = $NavigationAgent3D

@onready var progress_bar = $SubViewport/Hunger
@onready var progress_bar2 = $SubViewport/Repo
@onready var progress_bar3 = $SubViewport/Gender

@onready var creature_manager

@onready var progress_bar_text = $SubViewport/RichTextLabel
@onready var progress_bar_text2 = $SubViewport/RichTextLabel2
@onready var progress_bar_text3 = $SubViewport/RichTextLabel3

@onready var self_area = $Self

var generation = 0

var move = true

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
	$Age.set_wait_time(lifespan)
	
	creature_manager = Engine.get_singleton("CreatureManager")
	
	# Check if the singleton instance exists before calling its methods
	if creature_manager != null:
		# Call methods on the singleton instance
		creature_manager.add_creature(self)
		creature_manager.add_fire_creature(self)
		creature_manager.add_fire_prey(self)
		#print(creature_manager.get_total_creatures())
	else:
		print("CreatureManager singleton instance is not initialized.")
		
	$Timer.start()
	
	time_since_last_target_update = TARGET_UPDATE_INTERVAL

	if is_child:
		# If this instance is a child, start the timer for transitioning parameters
		#print("Child timer started")
		$Child_Timer.start()
		# Scale down the size
		# size *= child_scale_factor
		self.scale = Vector3(size,size,size)
		inital_hunger = hunger
		is_female = randf() < 1.0 / 3.0   # Randomly assign true (female) or false (male)
		
		#print("Baby born Size: ", size , " Accel: ", accel," Speed: ",speed, " Hunger: ", inital_hunger, " Meta: ", metabolism, " Female: ", is_female)
		#print(mother)
		
		#start_following_mother()
		
	else:
		
		# If it's not a child (i.e., an adult), initialize random size, speed, and hunger capacity
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
		
		creature_manager.add_fire_gen(generation)
		creature_manager.fire_prey_gen_score(a, self.generation)
		
		$Age.start()
	
	hunger_half = hunger/2
	
	progress_bar.max_value = hunger
	progress_bar.min_value = 0
	progress_bar2.max_value = 1
	progress_bar2.min_value = 0
	progress_bar3.value = progress_bar3.max_value
	
	if is_female:
		
		#print("Female")
		var desired_color = Color(1.0, 0.75, 0.8)
		progress_bar3.modulate = desired_color
		progress_bar_text3.text = "Female"
		
		var material = load("res://Assets/CreatureShaders/Fire_Prey.tres").duplicate()  # Load the material and duplicate it
		material.albedo_color = Color(1.0, 0.2, 0.3)  # Set the new color
	
		$Body.set_surface_override_material(0,material) 
		$Arm.set_surface_override_material(0,material) 
		$Arm/Arm.set_surface_override_material(0,material) 
		$Arm2.set_surface_override_material(0,material) 
		$Arm2/Arm.set_surface_override_material(0,material) 
		$Arm3.set_surface_override_material(0,material) 
		$Arm3/Arm.set_surface_override_material(0,material) 
		
	else:
		#print("Male")
		
		var desired_color = Color(0.5, 0.5, 1.0)
		progress_bar3.modulate = desired_color
		progress_bar_text3.text = "Male"

	creature_manager.add_fire_prey_gender(is_female)

func _process(delta):
	
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
		creature_manager.remove_creature(self)
		creature_manager.remove_fire_creature(self)
		creature_manager.remove_fire_prey(self)
	
	if progress_bar.value > 0:
		progress_bar.value = hunger
		progress_bar_text.text = "Food : " + str(hunger)
		
	if hunger > hunger_half:
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
	
	if is_child and mother != null:
		nav.target_position = mother.global_position
	
	
	if nav.target_position != global_position:
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
	else:
		rotation = Vector3(0,rotation.y,0)
		
	time_since_last_target_update += delta
	
	calculate_movement(delta)
	
	if velocity == Vector3.ZERO:
		move = true
		# Check if the target is 1 unit away from the target position
	
	if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
		move = true
		time_since_last_target_update = 0.0
	
	if nav.target_position != Vector3.ZERO:
		var distance_to_target = global_position.distance_to(nav.target_position)
		if distance_to_target <= 1.0:
			move = true
			velocity = Vector3.ZERO
			
			
func calculate_movement(delta):

	direction = nav.get_next_path_position() - global_position
	direction = direction.normalized()
	velocity = velocity.lerp(direction * speed, accel * delta)
	move_and_slide()

func _hungry():
	
	if hunger >= hunger_half:
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
	
	if area.is_in_group("fire_food") && _hungry():
		
		#print("Prey : Food spotted")
		food_target = true
		target_pos = area.global_position
		nav.target_position = target_pos
		
	if area.is_in_group("fire_pred") and !is_child:
		enemy = area
		$StateChart.send_event("enemy_entered")
		time_since_last_target_update = randf_range(1.0, 10.0)  # Start running immediately
		
	if is_female and !is_child and reproduction == 1:
		if area.is_in_group("fire_prey") and !has_mated and !area.get_parent().is_female and partners != 2 and !area.get_parent().is_child and area.get_parent().reproduction == 1:
			
			if mating_partner_1 == null:
				
				#print("Partner 1 spotted")
				$Looking.start()
				mating_partner_1 = area
				
				# Save the stats of the first encountered mate
				first_mate_size = mating_partner_1.get_parent().size
				first_mate_hunger = mating_partner_1.get_parent().hunger
				
				#print("Average Score 1: ", first_mate_size + first_mate_hunger)
				partners += 1
				
			elif mating_partner_2 == null and area != mating_partner_1:
				
				#print("Partner 2 spotted")
				mating_partner_2 = area
				
				# Compare stats with the second mate
				var second_mate_size = area.get_parent().size
				var second_mate_hunger = area.get_parent().hunger
				
				#print("Average Score 2: ", second_mate_size + second_mate_hunger)
				
				if second_mate_size + second_mate_hunger > first_mate_size + first_mate_hunger:
					# Second mate is better, mate with it
					mating_partner_2 = area
					first_mate_size = second_mate_size
					first_mate_hunger = second_mate_hunger
					mate_chosen = 2
				# else: Stick with the first mate
				partners += 1
				
			if partners == 2:
				pass
				#print("Mating with : ", mate_chosen)

func _on_self_area_entered(area):
	if area.is_in_group("fire_pred") and area.get_parent()._hungry():
		
		#print("Dead")
		queue_free()
		creature_manager.remove_creature(self)
		creature_manager.remove_fire_creature(self)
		
		creature_manager.remove_fire_prey(self)
		
	#If food enters self area, it gets eaten
	if area.is_in_group("fire_food"):
		food_target = false
		hunger += 1
		#print("Prey: Food ate")
		
	if area.is_in_group("fire_prey") and partners == 2 and area == mating_partner:
		#print("Mate: ", mate_chosen, " Touched Sending Repo State")
		$StateChart.send_event("repo")
	
#If Pred Leaves The Sensory Area
func _on_sensory_area_exited(area):
	if area.is_in_group("fire_pred"):
		$StateChart.send_event("enemy_exited")

func _on_wandering_state_entered():
	var num_escape_directions = 3
	escape_directions.clear()
	
	# Calculate escape directions: front, left, and right
	escape_directions.append(global_transform.basis.z.normalized()) # Front
	escape_directions.append(global_transform.basis.x.normalized()) # Left
	escape_directions.append(-global_transform.basis.x.normalized()) # Right
	
	# Randomize the escape directions slightly
	for i in range(escape_directions.size()):
		escape_directions[i] = escape_directions[i].rotated(Vector3.UP, randf_range(-PI / 4, PI / 4))
	
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
		var new_target_position = global_position + direction_to_enemy * 10
		
		# Set the navigation target to the new target position
		nav.target_position = new_target_position
		
		# Reset the timer
		time_since_last_target_update = 0.0

func _on_wandering_state_processing(delta):
	
	time_since_last_target_update += delta
	# Childer Will Follow Mother Instead
	if !is_child:
		if partners == 2:
			if mate_chosen == 1:
				mating_partner = mating_partner_1
				if is_instance_valid(mating_partner):
					nav.target_position = mating_partner.global_position
				else:
					has_mated = true
					mating_partner = null
					partners = 0
					$StateChart.send_event("repo_done")
					#print("Has Died")
			else: 
				mating_partner = mating_partner_2
				if is_instance_valid(mating_partner):
					nav.target_position = mating_partner.global_position
				else:
					has_mated = true
					mating_partner = null
					partners = 0
					$StateChart.send_event("repo_done")
					#print("Has Died")
		else: 
			if food_target == false and move == true:
				# Continue wandering
				var random_dir = Vector3(randf_range(-0.5, 0.5), 0.1, randf_range(-0.5, 0.5)).normalized()
				target_pos = global_position + Vector3(random_dir.x * roam_size, 0.1, random_dir.z * roam_size)
				nav.target_position = target_pos
				move = false

func _on_repo_state_entered():
	
	# Reproduction state entered
	if mating_partner != null:
		
		#print("In Repo state")
		var max_size = max(size, mating_partner.get_parent().size)
		var max_speed = max(inital_speed, mating_partner.get_parent().inital_speed)
		var max_accel = max(accel, mating_partner.get_parent().accel)
		var max_hunger = max(inital_hunger, mating_partner.get_parent().inital_hunger)
		var max_meta = max(metabolism, mating_partner.get_parent().metabolism)
	
		var par1 = (size + accel + inital_speed + inital_hunger + metabolism) / 5
		var par2 = (mating_partner.get_parent().size + mating_partner.get_parent().inital_speed 
		+ mating_partner.get_parent().accel + mating_partner.get_parent().inital_hunger
		 + mating_partner.get_parent().metabolism ) / 5
	
		#print("Parent Average 1 ", par1)
		#print(" Size: ", size , " Accel: ", accel," Speed: ",inital_speed, " Hunger: ", inital_hunger, " Meta: ", metabolism, " Female: ", is_female)
		
		#print("Parent Average 2 ", par2)
		#print(" Size: ", mating_partner.get_parent().size , " Accel: ", mating_partner.get_parent().accel, " Speed: ",mating_partner.get_parent().inital_speed, " Hunger: ", mating_partner.get_parent().inital_hunger, " Meta: ", mating_partner.get_parent().metabolism, " Female: ", mating_partner.get_parent().is_female)
		
		var twins = randi_range(1, 2) == 1 
		
		if twins :
			create_child(max_size, max_speed, max_accel, max_hunger, max_meta,self_area,speed_counter, speed)
			create_child(max_size, max_speed, max_accel, max_hunger, max_meta,self_area,speed_counter, speed)
			$Mating.start()
			
		else:
			create_child(max_size, max_speed, max_accel, max_hunger, max_meta,self_area,speed_counter, speed)
			$Mating.start()
			
		has_mated = true
		mating_partner = null
		partners = 0
		
		# Reset mating_partner for future reproduction
		$StateChart.send_event("repo_done")

func create_child(size,inital_speed,accel,hunger,meta,mother_area,speed_counter, speed):
	
	# Create a new instance of the same creature as a child
	var child = load("res://Scenes/Prey/Fire_Prey.tscn").instantiate()
	
	var child_generation = generation + 1
	
	child.speed_counter = speed_counter
	child.mother = mother_area
	child.size = size * child_scale_factor
	child.speed = speed
	child.inital_speed = inital_speed * child_factor
	child.accel = accel * child_factor
	child.hunger = hunger * child_factor
	child.metabolism = meta * child_factor
	child.is_child = true  # Mark the child as a child
	child.generation = child_generation
	
	
	
	get_parent().add_child(child)
	
	# Position the child nearby the parent
	child.global_position = global_position + Vector3(randi_range(-1, 1), 0, randi_range(-1, 1))

# Function to check if a point is inside a polygon
func is_point_inside_polygon(point: Vector3, polygon: Array) -> bool:
	var wn = 0
	for i in range(polygon.size() - 1):
		var v1 = polygon[i]
		var v2 = polygon[i + 1]
		if v1.z <= point.z and point.z < v2.z or v2.z <= point.z and point.z < v1.z:
			if point.x < (v2.x - v1.x) * (point.z - v1.z) / (v2.z - v1.z) + v1.x:
				wn += 1
	return wn % 2 != 0

# Helper function to determine if a point is on the left side of a line
func is_left(v1: Vector3, v2: Vector3, point: Vector3) -> float:
	return (v2.x - v1.x) * (point.z - v1.z) - (point.x - v1.x) * (v2.z - v1.z)

func _on_child_timer_timeout():
	
	#print("baby done")
	
	is_child = false
	
	size /= child_scale_factor
	inital_speed /= child_factor
	accel /= child_factor
	inital_hunger /= child_factor
	metabolism /= child_factor
	
	var random_index = randi_range(0, 4)
	
	# Increment the selected variable by 1.0
	match random_index:
		0:
			size += 0.25
		1:
			inital_speed += 0.5
		2:
			accel += 0.5
		3:
			inital_hunger += 0.5
		4:
			metabolism += 0.5
	
	self.scale = Vector3(size,size,size)
	
	var a = (size + accel + inital_speed + inital_hunger + metabolism) / 5
	
	creature_manager.fire_prey_gen_score(a, self.generation)
	creature_manager.add_fire_gen(self.generation)
	
	
	$Age.start()

func _on_mating_timeout():
	has_mated = false
	mating_partner_1 = null
	mating_partner_2 = null
	partners = 0
	mate_chosen = 1

func _on_looking_timeout():
	partners = 2
	mate_chosen = 1

func _on_age_timeout():
	queue_free()
	creature_manager.remove_creature(self)
	creature_manager.remove_fire_creature(self)
	creature_manager.remove_fire_prey(self)
