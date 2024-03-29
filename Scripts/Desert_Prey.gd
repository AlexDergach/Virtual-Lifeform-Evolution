extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var progress_bar = $SubViewport/Hunger
@onready var progress_bar2 = $SubViewport/Repo
@onready var progress_bar_text = $SubViewport/RichTextLabel
@onready var progress_bar_text2 = $SubViewport/RichTextLabel2
var roam_size = 20.0

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
var stop = false

var food_target = false
var food_location:Vector3 = Vector3.ZERO


var direction = Vector3()
var speed = 2
var accel = 5

var hunger_label: Label3D
var reproduction_label: Label3D
#@onready var hunger_bar: TextureProgressBar = $Control/TextureProgressBar
var time_since_last_target_update = 0.0


func _ready():
	
	$Timer.start()
	
	#hunger_label = Label3D.new()
	#hunger_label.text = "Hunger: " + str(hunger)
	#hunger_label.font = load("res://Assets/Fonts/Roboto-Black.ttf")
	#hunger_label.modulate = Color(0.0, 1.0, 0.0)
	#hunger_label.outline_modulate = Color(0, 0, 0, 1)  # Black outline
	#add_child(hunger_label)

	# Create and configure reproduction label
	#reproduction_label = Label3D.new()
	#reproduction_label.text = "Reproduction: " + str(reproduction)
	#reproduction_label.font = load("res://Assets/Fonts/Roboto-Black.ttf")
	#hunger_label.modulate = Color(1.0, 0.0, 1.0)
	#reproduction_label.outline_modulate = Color(0, 0, 0, 1)  # Black outline
	#add_child(reproduction_label)


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
	#hunger_label.global_position = global_position
	#hunger_label.global_position.y += 1.25
	
	#reproduction_label.global_position = global_position
	#reproduction_label.global_position.y += 1.5

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
	# Calculate movement based on the new rotation
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
	
var enemy = null
var rotation_speed = 5.0


func _on_sensory_area_entered(area):
	
	if area.is_in_group("desert_food") && _hungry():
		print("Food spotted")
		food_target = true
		food_location = area.global_position
		nav.target_position = food_location

func _on_self_area_entered(area):
	if area.is_in_group("desert_pred"):
		print("here")
		queue_free()
	#If food enters self area, it gets eaten
	if area.is_in_group("desert_food"):
		food_target = false
		hunger += 1
		print("food ate")

#If Pred Leaves The Sensory Area

#Check if both work
func _on_sensory_body_exited(body):
	if body.is_in_group("desert_pred"):
		$StateChart.send_event("enemy_exited")

func _on_sensory_area_exited(area):
	if area.is_in_group("desert_pred"):
		print("in here")
		$StateChart.send_event("enemy_exited")

func _on_wandering_state_entered():
	#fix back to wander?
	enemy = null


#Once Enemy enters The Sensory Area
func _on_sensory_body_entered(body):
	if body.is_in_group("desert_pred"):
		print("Enemy Entered Area")
		enemy = body
		$StateChart.send_event("enemy_entered")

func _on_running_state_processing(delta):
	print("Running")
	look_at(Vector3(enemy.global_position.x, 1 ,enemy.global_position.z), Vector3.UP, false)


func _on_wandering_state_processing(delta):
	var TARGET_UPDATE_INTERVAL = randf_range(2.0,5.0)
	time_since_last_target_update += time
	print(TARGET_UPDATE_INTERVAL)
	
	if food_target == false:
		if time_since_last_target_update >= TARGET_UPDATE_INTERVAL:
			print("Wandering")
			var random_dir = Vector2(randf_range(-1.0, 1.0), randf_range(-1.0, 1.0)).normalized()
			target_pos = global_position + Vector3(random_dir.x * roam_size, 0.1, random_dir.y * roam_size)
			nav.target_position = target_pos
			
			time_since_last_target_update = 0.0
	
