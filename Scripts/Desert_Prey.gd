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
const TARGET_UPDATE_INTERVAL = 1.0
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
		
	if hunger == 0:
		reproduction = 0
	else: 
		reproduction = 1
	#hunger_label.global_position = global_position
	#hunger_label.global_position.y += 1.25
	
	#reproduction_label.global_position = global_position
	#reproduction_label.global_position.y += 1.5
	
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

func _on_sensory_area_entered(area):
	if area.is_in_group("food"):
		food_target = true
		food_location = area.global_position


func _on_self_body_entered(body):
	if body.is_in_group("pred"):
		print("here")
		queue_free()
