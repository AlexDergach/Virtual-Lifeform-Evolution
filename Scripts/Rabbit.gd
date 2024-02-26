extends CharacterBody3D

@onready var nav: NavigationAgent3D = $NavigationAgent3D
@onready var roam_size = get_node("../NavigationRegion3D/CSGBox3D").get_scale()

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
	
func _physics_process(delta):

	time += delta
	if time >= 2.0:
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
				target_pos = Vector3(randf_range(-roam_size.x/2,roam_size.x/2),0.1,randf_range(-roam_size.z/2,roam_size.z/2))
				stop = true
		time = 0.0
		
		#print("Amount Eaten= ",hunger)
		#print("Hungry= ",_hungry())
		#print("Food Spotted=",food_target)
		
	
	
		
	nav.target_position = target_pos

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
