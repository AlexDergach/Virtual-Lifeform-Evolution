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
		
		var total_desert_creature_count = creature_manager.get_desert_creature()
		var total_desert_creature_prey_count = creature_manager.get_desert_prey()
		var total_desert_creature_pred_count = creature_manager.get_desert_pred()
		print("Total Desert Creature Amount: ",total_desert_creature_count ," Total Pred Amount: ", 
		total_desert_creature_pred_count ," Total Prey Amount: ",total_desert_creature_prey_count)
		
		var full_gender_desert_amount_male = creature_manager.get_desert_gender(false)
		var full_gender_desert_amount_female = creature_manager.get_desert_gender(true)
		print("Full desert male gender: ",full_gender_desert_amount_male ,
		" Full desert female gender: ",full_gender_desert_amount_female )
		var full_gender_desert_pred_amount_male = creature_manager.get_desert_pred_gender(false)
		var full_gender_desert_pred_amount_female = creature_manager.get_desert_pred_gender(true)
		print("Full desert pred male gender: ",full_gender_desert_pred_amount_male ,
		" Full desert pred female gender: ",full_gender_desert_pred_amount_female )
		var full_gender_desert_prey_amount_male = creature_manager.get_desert_prey_gender(false)
		var full_gender_desert_prey_amount_female = creature_manager.get_desert_prey_gender(true)
		print("Full desert prey male gender: ",full_gender_desert_prey_amount_male ,
		" Full desert prey female gender: ",full_gender_desert_prey_amount_female )

		
		var highest_desert_gen_reach = creature_manager.get_desert_gen()
		print("Higest Desert Gen Reached: ", highest_desert_gen_reach)

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
			
				# Call the function to get the highest scores
		var highest_iprey_scores = creature_manager.ice_prey_highest_gen_score()
		var highest_ice_gen_reach = creature_manager.get_ice_gen()
		print("Higest Ice Gen Reached: ", highest_ice_gen_reach)
		
		var total_ice_creature_count = creature_manager.get_ice_creature()
		print("Total Ice Creature Amount: ",total_ice_creature_count)
		
		var full_gender_ice_amount_male = creature_manager.get_ice_gender(false)
		var full_gender_ice_amount_female = creature_manager.get_ice_gender(true)
		print("Full Fire male gender: ",full_gender_ice_amount_male ,
		" Full Fire female gender: ",full_gender_ice_amount_female )

		# Iterate through the results and print them
		for result in highest_iprey_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score: ", highest_score)


				# Call the function to get the highest scores
		var highest_fiprey_scores = creature_manager.fire_prey_highest_gen_score()
		var highest_fipred_scores = creature_manager.fire_pred_highest_gen_score()
		var highest_fire_gen_reach = creature_manager.get_fire_gen()
		print("Higest Fire Gen Reached: ", highest_fire_gen_reach)

		var total_fire_creature_count = creature_manager.get_fire_creature()
		var total_fire_creature_prey_count = creature_manager.get_fire_prey()
		var total_fire_creature_pred_count = creature_manager.get_fire_pred()
		print("Total Fire Creature Amount: ",total_fire_creature_count ," Total Pred Amount: ", 
		total_fire_creature_prey_count ," Total Prey Amount: ",total_fire_creature_pred_count)
		
		var full_gender_fire_amount_male = creature_manager.get_fire_gender(false)
		var full_gender_fire_amount_female = creature_manager.get_fire_gender(true)
		print("Full Fire male gender: ",full_gender_fire_amount_male ,
		" Full Fire female gender: ",full_gender_fire_amount_female )
		var full_gender_fire_pred_amount_male = creature_manager.get_fire_pred_gender(false)
		var full_gender_fire_pred_amount_female = creature_manager.get_fire_pred_gender(true)
		print("Full Fire pred male gender: ",full_gender_fire_pred_amount_male ,
		" Full Fire pred female gender: ",full_gender_fire_pred_amount_female )
		var full_gender_fire_prey_amount_male = creature_manager.get_fire_prey_gender(false)
		var full_gender_fire_prey_amount_female = creature_manager.get_fire_prey_gender(true)
		print("Full Fire prey male gender: ",full_gender_fire_prey_amount_male ,
		" Full Fire prey female gender: ",full_gender_fire_prey_amount_female )



		# Iterate through the results and print them
		for result in highest_fiprey_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score: ", highest_score)
			
				# Call the function to get the highest scores

		# Iterate through the results and print them
		for result in highest_fipred_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score Pred: ", highest_score)

		var highest_fprey_scores = creature_manager.forest_prey_highest_gen_score()
		var highest_fpred_scores = creature_manager.forest_pred_highest_gen_score()
		var highest_forest_gen_reach = creature_manager.get_forest_gen()
		print("Higest Forest Gen Reached: ", highest_forest_gen_reach)
		
		
		var total_forest_creature_count = creature_manager.get_forest_creature()
		var total_forest_creature_prey_count = creature_manager.get_forest_prey()
		var total_forest_creature_pred_count = creature_manager.get_forest_pred()
		print("Total Forest Creature Amount: ",total_forest_creature_count ," Total Pred Amount: ", 
		total_forest_creature_prey_count ," Total Prey Amount: ",total_forest_creature_pred_count)
		
		var full_gender_forest_amount_male = creature_manager.get_forest_gender(false)
		var full_gender_forest_amount_female = creature_manager.get_forest_gender(true)
		print("Full Forest male gender: ",full_gender_forest_amount_male ,
		" Full Forest female gender: ",full_gender_forest_amount_female )
		var full_gender_forest_pred_amount_male = creature_manager.get_forest_pred_gender(false)
		var full_gender_forest_pred_amount_female = creature_manager.get_forest_pred_gender(true)
		print("Full Forest pred male gender: ",full_gender_forest_pred_amount_male ,
		" Full Forest pred female gender: ",full_gender_forest_pred_amount_female )
		var full_gender_forest_prey_amount_male = creature_manager.get_forest_prey_gender(false)
		var full_gender_forest_prey_amount_female = creature_manager.get_forest_prey_gender(true)
		print("Full Forest prey male gender: ",full_gender_forest_prey_amount_male ,
		" Full Forest prey female gender: ",full_gender_forest_prey_amount_female )


		# Iterate through the results and print them
		for result in highest_fprey_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score: ", highest_score)
			
				# Call the function to get the highest scores

		# Iterate through the results and print them
		for result in highest_fpred_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score Pred: ", highest_score)
			
		var highest_sprey_scores = creature_manager.stone_prey_highest_gen_score()
		var highest_spred_scores = creature_manager.stone_pred_highest_gen_score()
		var highest_stone_gen_reach = creature_manager.get_stone_gen()
		print("Higest Stone Gen Reached: ", highest_stone_gen_reach)

		var total_stone_creature_count = creature_manager.get_stone_creature()
		var total_stone_creature_prey_count = creature_manager.get_stone_prey()
		var total_stone_creature_pred_count = creature_manager.get_stone_pred()
		print("Total Stone Creature Amount: ",total_stone_creature_count ," Total Pred Amount: ", 
		total_stone_creature_prey_count ," Total Prey Amount: ",total_stone_creature_pred_count)
		
		var full_gender_stone_amount_male = creature_manager.get_stone_gender(false)
		var full_gender_stone_amount_female = creature_manager.get_stone_gender(true)
		print("Full Stone male gender: ",full_gender_stone_amount_male ,
		" Full Stone female gender: ",full_gender_stone_amount_female )
		var full_gender_stone_pred_amount_male = creature_manager.get_stone_pred_gender(false)
		var full_gender_stone_pred_amount_female = creature_manager.get_stone_pred_gender(true)
		print("Full Stone pred male gender: ",full_gender_stone_pred_amount_male ,
		" Full Stone pred female gender: ",full_gender_stone_pred_amount_female )
		var full_gender_stone_prey_amount_male = creature_manager.get_stone_prey_gender(false)
		var full_gender_stone_prey_amount_female = creature_manager.get_stone_prey_gender(true)
		print("Full Stone prey male gender: ",full_gender_stone_prey_amount_male ,
		" Full Stone prey female gender: ",full_gender_stone_prey_amount_female )




		# Iterate through the results and print them
		for result in highest_sprey_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score: ", highest_score)
			
				# Call the function to get the highest scores

		# Iterate through the results and print them
		for result in highest_spred_scores:
			var gen = result[0]
			var highest_score = result[1]
			print("Generation: ", gen, " Highest Score Pred: ", highest_score)
			
			
			
			
			
		
		var final_creature_count = creature_manager.get_final_total_creatures()
		print("Full creature count: ", final_creature_count)
		
		var full_female_creatures = creature_manager.get_creature_gender(true)
		var full_males_creatures = creature_manager.get_creature_gender(false)
		print("Full Female Count: ", full_female_creatures, " Full Male Count: ",full_males_creatures)
				
		get_tree().quit()

func _on_timer_timeout():
	_spawn_food()
	_spawn_food()
	pass

