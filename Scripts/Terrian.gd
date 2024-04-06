extends Node3D

@onready var creature_manager
var ui_instance


var ui_scene = load("res://UI/UI.tscn")

var scene = "Desert"
var food_scene = load("res://Scenes/Food/"+ scene + "_Food.tscn")
var prey_scene = load("res://Scenes/Prey/"+ scene + "_Prey.tscn")
var pred_scene = load("res://Scenes/Pred/"+ scene + "_Pred.tscn")

var food_size = 0.5
var spawn_rate = 1
var rabbit_instance
var enemy_instance
var food_instance

var rabbit_instances = []



@onready var map_size = get_node("NavigationRegion3D/CSGBox3D").get_scale()
func _ready():
	
	creature_manager = Engine.get_singleton("CreatureManager")

	
	
	ui_instance = ui_scene.instantiate()
	add_child(ui_instance)
	
	randomize()
	$Timer.start()

func _process(delta):
	ui_instance.desert_label.text = "Desert Population: " + str(creature_manager.get_desert_creature()) + "
								Predators: " + str(creature_manager.get_desert_pred()) + "
								Prey: " + str(creature_manager.get_desert_prey()) + "
								Generation: " + str(creature_manager.get_desert_gen())
	
	ui_instance.fire_label.text = "Desert Population: " + str(creature_manager.get_fire_creature()) + "
							Predators: " + str(creature_manager.get_fire_pred()) + "
							Prey: " + str(creature_manager.get_fire_prey()) + "
							Generation: " + str(creature_manager.get_fire_gen())
							
	ui_instance.forest_label.text = "Forest Population: " + str(creature_manager.get_forest_creature()) + "
						Predators: " + str(creature_manager.get_forest_pred()) + "
						Prey: " + str(creature_manager.get_forest_prey()) + "
						Generation: " + str(creature_manager.get_forest_gen())
						
	ui_instance.ice_label.text = "Ice Population: " + str(creature_manager.get_ice_creature()) + "
						Prey: " + str(creature_manager.get_ice_prey()) + "
						Generation: " + str(creature_manager.get_ice_gen())
						
	ui_instance.stone_label.text = "Stone Population: " + str(creature_manager.get_stone_creature()) + "
						Predators: " + str(creature_manager.get_stone_pred()) + "
						Prey: " + str(creature_manager.get_stone_prey()) + "
						Generation: " + str(creature_manager.get_stone_gen())
								
	ui_instance.TotalPopLabel.text = "Total Population: " + str(creature_manager.get_total_creatures()) 
								
	pass

func _spawn_food():
	food_instance = food_scene.instantiate()
	food_instance.position.x = randf_range(-map_size.x,map_size.x)
	food_instance.position.z = randf_range(-map_size.z,map_size.z)
	food_instance.position.y = map_size.y + food_size/2
	add_child(food_instance)

func _spawn_rabbit():
	rabbit_instance = prey_scene.instantiate()
	rabbit_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	rabbit_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	rabbit_instance.position.y = map_size.y + 1
	add_child(rabbit_instance)
	rabbit_instances.append(rabbit_instance)


func _spawn_enemy():
	enemy_instance = pred_scene.instantiate()
	enemy_instance.position.x = randf_range(-map_size.x/2.1,map_size.x/2.1)
	enemy_instance.position.z = randf_range(-map_size.z/2.1,map_size.z/2.1)
	enemy_instance.position.y = 0.1
	add_child(enemy_instance)

func _physics_process(delta):
	
	if spawn_rate == 1:
		
		
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		_spawn_rabbit()
		
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		_spawn_enemy()
		
		spawn_rate = 0
		
	if Input.is_action_just_pressed("SpeedUp"):
		
		pass
		# Increase speed of all prey instances
	if Input.is_action_just_pressed("SpeedDown"):
		pass
	if Input.is_action_just_pressed("Exit"):
		
	
		# Call the function to get the highest scores
		var highest_dprey_scores = creature_manager.desert_prey_highest_gen_score()
		var highest_dpred_scores = creature_manager.desert_pred_highest_gen_score()


		# Iterate through the results and print them
		for result in highest_dprey_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score: ", highest_score)
			
				# Call the function to get the highest scores

		# Iterate through the results and print them
		for result in highest_dpred_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score Pred: ", highest_score)

		
		get_tree().quit()

func _on_timer_timeout():
	_spawn_food()
	_spawn_food()
	pass

