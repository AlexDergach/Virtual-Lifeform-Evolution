extends CharacterBody3D

var speed
var cameraRotaion = 0.005
var default_fov = 80
var sprint_fov_increase = 15
var fov_change_speed = 50.0

# For pivot of Camera
@onready var head = $Camera
@onready var camera = $Camera/Camera3D
@onready var ocean = $"../Ocean"

var flying = true  # Start in flying state
var fly_speed = 10.0
var ascend_speed = 5.0
var descend_speed = 15.0 
var last_jump_time = 0.0
var double_jump_threshold = 500  # milliseconds

var sprinting = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	set_process(true)

func _unhandled_input(event):
	if event is InputEventMouseMotion:
		head.rotate_y(-event.relative.x * cameraRotaion)
		camera.rotate_x(-event.relative.y * cameraRotaion)
		camera.rotation.x = clamp(camera.rotation.x, deg_to_rad(-90), deg_to_rad(60))
	elif event is InputEventKey and event.pressed:
		if Input.is_action_just_pressed("Jump"):
			var current_time = Time.get_ticks_msec()
			if current_time - last_jump_time < double_jump_threshold:
				flying = not flying
			last_jump_time = current_time
		elif Input.is_action_just_pressed("Ctrl"):
			velocity.y = -descend_speed
		elif Input.is_action_just_pressed("Sprint"):
			sprinting = true
			speed = 9.0
			camera.fov = default_fov + sprint_fov_increase

	elif event is InputEventKey and not event.pressed:
		if Input.is_action_just_released("Sprint"):
			sprinting = false

func _physics_process(delta):
	
	var target_fov: float

	if sprinting:
		target_fov = default_fov + sprint_fov_increase
	else:
		target_fov = default_fov

	if camera.fov != target_fov:
		var fov_change = fov_change_speed * delta
		if camera.fov < target_fov:
			camera.fov = min(camera.fov + fov_change, target_fov)
		else:
			camera.fov = max(camera.fov - fov_change, target_fov)
	
	if not flying and not is_on_floor():
		velocity.y -= 7 * delta 

	if not flying and Input.is_action_just_pressed("Jump") and is_on_floor():
		velocity.y = 5.0

	if flying:
		if Input.is_action_pressed("Sprint"):
			speed = 500.0
			ascend_speed = 10.0  # Increase ascend speed when sprinting
		else:
			speed = 5.0
	else:
		if Input.is_action_pressed("Sprint"):
			speed = 9.0
		else:
			speed = 5.0

	var input_dir = Input.get_vector("Left", "Right", "Forward", "Back")
	var direction = (head.transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()

	if flying:
		if Input.is_action_pressed("Jump"):
			velocity.y = ascend_speed
		elif Input.is_action_pressed("Ctrl"):
			velocity.y = -descend_speed
		else:
			velocity.y = 0
		velocity.x = direction.x * fly_speed
		velocity.z = direction.z * fly_speed
	else:
		velocity.x = direction.x * speed
		velocity.z = direction.z * speed

	if is_on_floor() and not flying:
		if direction:
			velocity.x = direction.x * speed
			velocity.z = direction.z * speed
		else:
			velocity.x = lerp(velocity.x, direction.x * speed, delta * 7.0)
			velocity.z = lerp(velocity.z, direction.z * speed, delta * 7.0)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, delta * 3.0)
		velocity.z = lerp(velocity.z, direction.z * speed, delta * 3.0)

	move_and_slide()

func _process(delta):
	pass
	ocean.position.x = self.position.x
	ocean.position.z = self.position.z

