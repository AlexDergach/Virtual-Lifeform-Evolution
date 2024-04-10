extends Control

@onready var label = $Label

var creature_manager
var data
var excel_data
var loaded

# Called when the node enters the scene tree for the first time.
func _ready():
	
	Input.set_mouse_mode(Input.MOUSE_MODE_VISIBLE)
	
	creature_manager = Engine.get_singleton("CreatureManager")
	
	file_save()
	excel_save()

func file_save():
	
	data = "======================================================================================\n"
	data += "=================================     Data      ======================================\n"
	data += "======================================================================================\n\n\n\n"
	
	data += "================================ All Creatures =====================================\n\n"
	
	
	var time_take = creature_manager.get_time()
	data += "Time Taken to completion: " + str(time_take/60) + "\n"
	
	var start_spawn_size = creature_manager.starting_size
	data += "\nStarting Spawn Size: " + str(start_spawn_size) + "\n"
	
	var final_creature_count = creature_manager.get_final_total_creatures()
	data += str("\nFull creature count: ") + str(final_creature_count) + "\n"

	var full_female_creatures = creature_manager.get_creature_gender(true)
	var full_males_creatures = creature_manager.get_creature_gender(false)
	data += str("\nFull Female Count: ") + str(full_female_creatures) + str(" Full Male Count: ") + str(full_males_creatures) + "\n"
	

	
	
	data += "\n\n================================ Desert Creatures =====================================\n\n"
	
	
		# Call the function to get the highest scores
	var highest_dprey_scores = creature_manager.desert_prey_highest_gen_score()
	var highest_dpred_scores = creature_manager.desert_pred_highest_gen_score()

	var total_desert_creature_count = creature_manager.get_final_desert_creatures()
	var total_desert_creature_prey_count = creature_manager.get_final_desert_prey()
	var total_desert_creature_pred_count = creature_manager.get_final_desert_pred()

	data += str("Total Desert Creature Amount: ") + str(total_desert_creature_count) + str(" Total Pred Amount: ") + str(total_desert_creature_pred_count) + str(" Total Prey Amount: ") + str(total_desert_creature_prey_count) + "\n\n"

	var full_gender_desert_amount_male = creature_manager.get_desert_gender(false)
	var full_gender_desert_amount_female = creature_manager.get_desert_gender(true)

	data += str("Full desert male gender: ") + str(full_gender_desert_amount_male) + str(" Full desert female gender: ") + str(full_gender_desert_amount_female) + "\n"

	var full_gender_desert_pred_amount_male = creature_manager.get_desert_pred_gender(false)
	var full_gender_desert_pred_amount_female = creature_manager.get_desert_pred_gender(true)
	data += str("Full desert pred male gender: ") + str(full_gender_desert_pred_amount_male) + str(" Full desert pred female gender: ") + str(full_gender_desert_pred_amount_female)+ "\n"

	var full_gender_desert_prey_amount_male = creature_manager.get_desert_prey_gender(false)
	var full_gender_desert_prey_amount_female = creature_manager.get_desert_prey_gender(true)
	data += str("Full desert prey male gender: ") + str(full_gender_desert_prey_amount_male) + str(" Full desert prey female gender: ") + str(full_gender_desert_prey_amount_female) + "\n"

	var highest_desert_gen_reach = creature_manager.get_desert_gen()
	data += str("\nHigest Desert Gen Reached: ") + str(highest_desert_gen_reach) + "\n"

	# Iterate through the results and print them
	for result in highest_dprey_scores:
		
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Prey: ") + str(highest_score) + "\n" 

	# Iterate through the results and print them
	for result in highest_dpred_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Pred: ") + str(highest_score) + "\n"
		
	var all_gen_scores_desert_pred = creature_manager.desert_pred_gen
	var all_gen_scores_desert_prey = creature_manager.desert_prey_gen
	
	data += "\n"
	
	for gen in range(all_gen_scores_desert_prey.size()):
		data += "Generation: "+ str(gen) + " Prey Scores: "+ str(all_gen_scores_desert_prey[gen]) + "\n"
	for gen in range(all_gen_scores_desert_pred.size()):
		data += "Generation: "+ str(gen) + " Pred Scores: "+  str(all_gen_scores_desert_pred[gen]) + "\n"


	data += "\n\n================================ Ice Creatures =====================================\n\n"


	var total_ice_creature_count = creature_manager.get_final_ice_creatures()
	data += str("Total Ice Creature Amount: ") + str(total_ice_creature_count) + "\n\n"
	
	var highest_iprey_scores = creature_manager.ice_prey_highest_gen_score()
	var highest_ice_gen_reach = creature_manager.get_ice_gen()
	data += str("\nHigest Ice Gen Reached: ") + str(highest_ice_gen_reach) + "\n"
	
	# Iterate through the results and print them
	for result in highest_iprey_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score: ") + str(highest_score) + "\n"
		
	var all_gen_scores_ice_prey = creature_manager.ice_prey_gen
	
	data += "\n"
	
	for gen in range(all_gen_scores_ice_prey.size()):
		data += "Generation: "+ str(gen) + " Scores: "+ str(all_gen_scores_ice_prey[gen]) + "\n"

	data += "\n\n================================ Fire Creatures =====================================\n\n"


	var total_fire_creature_count = creature_manager.get_final_fire_creatures()
	var total_fire_creature_prey_count = creature_manager.get_final_fire_prey()
	var total_fire_creature_pred_count = creature_manager.get_final_fire_pred()
	data += str("Total Fire Creature Amount: ") + str(total_fire_creature_count) + str(" Total Prey Amount: ") + str(total_fire_creature_prey_count) + str(" Total Pred Amount: ") + str(total_fire_creature_pred_count) + "\n\n"

	var full_gender_fire_amount_male = creature_manager.get_fire_gender(false)
	var full_gender_fire_amount_female = creature_manager.get_fire_gender(true)
	data += str("Full Fire male gender: ") + str(full_gender_fire_amount_male) + str(" Full Fire female gender: ") + str(full_gender_fire_amount_female) + "\n"

	var full_gender_fire_pred_amount_male = creature_manager.get_fire_pred_gender(false)
	var full_gender_fire_pred_amount_female = creature_manager.get_fire_pred_gender(true)
	data += str("Full Fire pred male gender: ") + str(full_gender_fire_pred_amount_male) + str(" Full Fire pred female gender: ") + str(full_gender_fire_pred_amount_female) + "\n"

	var full_gender_fire_prey_amount_male = creature_manager.get_fire_prey_gender(false)
	var full_gender_fire_prey_amount_female = creature_manager.get_fire_prey_gender(true)
	data += str("Full Fire prey male gender: ") + str(full_gender_fire_prey_amount_male) + str(" Full Fire prey female gender: ") + str(full_gender_fire_prey_amount_female) + "\n"

	var highest_fiprey_scores = creature_manager.fire_prey_highest_gen_score()
	var highest_fipred_scores = creature_manager.fire_pred_highest_gen_score()
	var highest_fire_gen_reach = creature_manager.get_fire_gen()
	data += str("\nHigest Fire Gen Reached: ") + str(highest_fire_gen_reach) + "\n"
	
	# Iterate through the results and print them
	for result in highest_fiprey_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Prey: ") + str(highest_score) + "\n"
		
		# Iterate through the results and print them
	for result in highest_fipred_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Pred: ") + str(highest_score) + "\n"

	var all_gen_scores_fire_pred = creature_manager.fire_pred_gen
	var all_gen_scores_fire_prey = creature_manager.fire_prey_gen
	
	data += "\n"
	
	for gen in range(all_gen_scores_fire_prey.size()):
		data += "Generation: "+ str(gen) + " Prey Scores: "+ str(all_gen_scores_fire_prey[gen]) + "\n"
	for gen in range(all_gen_scores_fire_pred.size()):
		data += "Generation: "+ str(gen) + " Pred Scores: "+  str(all_gen_scores_fire_pred[gen]) + "\n"

	data += "\n\n================================ Forest Creatures =====================================\n\n"


	var total_forest_creature_count = creature_manager.get_final_forest_creatures()
	var total_forest_creature_prey_count = creature_manager.get_final_forest_prey()
	var total_forest_creature_pred_count = creature_manager.get_final_forest_pred()
	data += str("\nTotal Forest Creature Amount: ") + str(total_forest_creature_count) + str(" Total Prey Amount: ") + str(total_forest_creature_prey_count) + str(" Total Pred Amount: ") + str(total_forest_creature_pred_count) + "\n"

	var full_gender_forest_amount_male = creature_manager.get_forest_gender(false)
	var full_gender_forest_amount_female = creature_manager.get_forest_gender(true)
	data += str("Full Forest male gender: ") + str(full_gender_forest_amount_male) + str(" Full Forest female gender: ") + str(full_gender_forest_amount_female) + "\n"

	var full_gender_forest_pred_amount_male = creature_manager.get_forest_pred_gender(false)
	var full_gender_forest_pred_amount_female = creature_manager.get_forest_pred_gender(true)
	data += str("Full Forest pred male gender: ") + str(full_gender_forest_pred_amount_male) + str(" Full Forest pred female gender: ") + str(full_gender_forest_pred_amount_female) + "\n"

	var full_gender_forest_prey_amount_male = creature_manager.get_forest_prey_gender(false)
	var full_gender_forest_prey_amount_female = creature_manager.get_forest_prey_gender(true)
	data += str("Full Forest prey male gender: ") + str(full_gender_forest_prey_amount_male) + str(" Full Forest prey female gender: ") + str(full_gender_forest_prey_amount_female) + "\n"

		
	var highest_fprey_scores = creature_manager.forest_prey_highest_gen_score()
	var highest_fpred_scores = creature_manager.forest_pred_highest_gen_score()
	var highest_forest_gen_reach = creature_manager.get_forest_gen()
	data += str("\nHigest Forest Gen Reached: ") + str(highest_forest_gen_reach) + "\n"


	# Iterate through the results and print them
	for result in highest_fprey_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Prey: ") + str(highest_score) + "\n"

	# Iterate through the results and print them
	for result in highest_fpred_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Pred: ") + str(highest_score) + "\n"
		
	var all_gen_scores_forst_pred = creature_manager.forest_pred_gen
	var all_gen_scores_forest_prey = creature_manager.forest_prey_gen
	
	data += "\n"	
	
	for gen in range(all_gen_scores_forest_prey.size()):
		data += "Generation: "+ str(gen) + " Prey Scores: "+ str(all_gen_scores_forest_prey[gen]) + "\n"
	for gen in range(all_gen_scores_forst_pred.size()):
		data += "Generation: "+ str(gen) + " Pred Scores: "+  str(all_gen_scores_forst_pred[gen]) + "\n"


	data += "\n\n================================ Stone Creatures =====================================\n\n"




	var total_stone_creature_count = creature_manager.get_final_stone_creatures()
	var total_stone_creature_prey_count = creature_manager.get_final_stone_prey()
	var total_stone_creature_pred_count = creature_manager.get_final_stone_pred()
	data += str("\nTotal Stone Creature Amount: ") + str(total_stone_creature_count) + str(" Total Prey Amount: ") + str(total_stone_creature_prey_count) + str(" Total Pred Amount: ") + str(total_stone_creature_pred_count) + "\n"

	var full_gender_stone_amount_male = creature_manager.get_stone_gender(false)
	var full_gender_stone_amount_female = creature_manager.get_stone_gender(true)
	data += str("Full Stone male gender: ") + str(full_gender_stone_amount_male) + str(" Full Stone female gender: ") + str(full_gender_stone_amount_female) + "\n" 

	var full_gender_stone_pred_amount_male = creature_manager.get_stone_pred_gender(false)
	var full_gender_stone_pred_amount_female = creature_manager.get_stone_pred_gender(true)
	data += str("Full Stone pred male gender: ") + str(full_gender_stone_pred_amount_male) + str(" Full Stone pred female gender: ") + str(full_gender_stone_pred_amount_female) + "\n"

	var full_gender_stone_prey_amount_male = creature_manager.get_stone_prey_gender(false)
	var full_gender_stone_prey_amount_female = creature_manager.get_stone_prey_gender(true)
	data += str("Full Stone prey male gender: ") + str(full_gender_stone_prey_amount_male) + str(" Full Stone prey female gender: ") + str(full_gender_stone_prey_amount_female) + "\n"

	var highest_sprey_scores = creature_manager.stone_prey_highest_gen_score()
	var highest_spred_scores = creature_manager.stone_pred_highest_gen_score()
	var highest_stone_gen_reach = creature_manager.get_stone_gen()
	data += str("\nHigest Stone Gen Reached: ") + str(highest_stone_gen_reach) + "\n"

	# Iterate through the results and print them
	for result in highest_sprey_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Prey: ") + str(highest_score) + "\n"

	# Iterate through the results and print them
	for result in highest_spred_scores:
		var gen = result[0]
		var highest_score = result[1]
		data += str("Generation: ") + str(gen) + str(" Highest Score Pred: ") + str(highest_score) + "\n"
		
	var all_gen_scores_stone_pred = creature_manager.stone_pred_gen
	var all_gen_scores_stone_prey = creature_manager.stone_prey_gen
	
	data += "\n"
	
	for gen in range(all_gen_scores_stone_prey.size()):
		data += "Generation: "+ str(gen) + " Prey Scores: "+ str(all_gen_scores_stone_prey[gen]) + "\n"
	for gen in range(all_gen_scores_stone_pred.size()):
		data += "Generation: "+ str(gen) + " Pred Scores: "+  str(all_gen_scores_stone_pred[gen]) + "\n"


	data += "\n\n\n======================================================================================\n"
	data += "=================================     End      ======================================\n"
	data += "======================================================================================\n"
	
	save(data)

	print("Done Saving")
	
	
func excel_save():
	var max_generation = ""
	var max_count
	var time_take = creature_manager.get_time()
	var start_spawn_size = creature_manager.starting_size
	var final_creature_count = creature_manager.get_final_total_creatures()
	var full_female_creatures = creature_manager.get_creature_gender(true)
	var full_males_creatures = creature_manager.get_creature_gender(false)
	
	excel_data = "Total Creature Amount,Total Female Count,Total Male Count,Starting Spawn Size,Time Taken\n"
	excel_data += "" + str(final_creature_count) + "," + str(full_female_creatures) + "," + str(full_males_creatures) + "," + str(start_spawn_size) + "," + str(time_take/60) + "\n\n" 
	
	#===================================================== Info ==============================

	
	max_count = max(creature_manager.get_desert_gen(), 
	creature_manager.get_ice_gen(),
	creature_manager.get_fire_gen(),
	creature_manager.get_forest_gen(),
	creature_manager.get_stone_gen())  
	
	print(max_count)
	
	max_count += 1
	for gen in max_count:
		max_generation += "Gen " + str(gen) + ","
		
	print(max_generation)

	excel_data += "Species,Total Species Amount,Predator Count,Prey Count,Female Count,Male Count,Higest Generation Reached," + max_generation + "\n"
	
	
	#=================================== Desert ====================================
	
	
		
	var highest_dprey_scores = creature_manager.desert_prey_highest_gen_score()
	var highest_dpred_scores = creature_manager.desert_pred_highest_gen_score()

	var total_desert_creature_count = creature_manager.get_final_desert_creatures()
	var total_desert_creature_prey_count = creature_manager.get_final_desert_prey()
	var total_desert_creature_pred_count = creature_manager.get_final_desert_pred()


	var full_gender_desert_amount_male = creature_manager.get_desert_gender(false)
	var full_gender_desert_amount_female = creature_manager.get_desert_gender(true)
	var highest_desert_gen_reach = creature_manager.get_desert_gen()
	
	excel_data += "Desert," +  str(total_desert_creature_count) + "," + str(total_desert_creature_pred_count) + "," + str(total_desert_creature_prey_count) + "," + str(full_gender_desert_amount_female) + "," + str(full_gender_desert_amount_male) + "," + str(highest_desert_gen_reach) + "\n"
	
	excel_data +=  "Higest Generational Scores\n"
	excel_data +=  "Prey, , , , , , ,"
	# Iterate through the results and print them
	for result in highest_dprey_scores:
		
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + "," 

	excel_data +=  "\nPredators, , , , , , ,"
	
	# Iterate through the results and print them
	for result in highest_dpred_scores:
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + ","
	
	excel_data += "\n\n"
	

	#=================================== Ice ====================================

	var total_ice_creature_count = creature_manager.get_final_ice_creatures()
	var highest_ice_gen_reach = creature_manager.get_ice_gen()
	var highest_iprey_scores = creature_manager.ice_prey_highest_gen_score()

	excel_data += "Ice," + str(total_ice_creature_count) + ", , , , ," + str(highest_ice_gen_reach) + "\n"
	
	excel_data +=  "Higest Generational Scores, , , , , , ,"
	
	for result in highest_iprey_scores:
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + ","
	
	excel_data += "\n\n"


	#=================================== Fire ====================================


	var total_fire_creature_count = creature_manager.get_final_fire_creatures()
	var total_fire_creature_prey_count = creature_manager.get_final_fire_prey()
	var total_fire_creature_pred_count = creature_manager.get_final_fire_pred()

	var full_gender_fire_amount_male = creature_manager.get_fire_gender(false)
	var full_gender_fire_amount_female = creature_manager.get_fire_gender(true)

	var highest_fiprey_scores = creature_manager.fire_prey_highest_gen_score()
	var highest_fipred_scores = creature_manager.fire_pred_highest_gen_score()
	var highest_fire_gen_reach = creature_manager.get_fire_gen()
	
	excel_data += "Fire," +  str(total_fire_creature_count) + "," + str(total_fire_creature_pred_count) + "," + str(total_fire_creature_prey_count) + "," + str(full_gender_fire_amount_female) + "," + str(full_gender_fire_amount_male) + "," + str(highest_fire_gen_reach) + "\n"
	
	excel_data +=  "Higest Generational Scores\n"
	excel_data +=  "Prey, , , , , , ,"
	# Iterate through the results and print them
	for result in highest_fiprey_scores:
		
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + "," 

	excel_data +=  "\nPredators, , , , , , ,"
	
	# Iterate through the results and print them
	for result in highest_fipred_scores:
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + ","
	
	excel_data += "\n\n"

	#=================================== Forest ====================================


	var total_forest_creature_count = creature_manager.get_final_forest_creatures()
	var total_forest_creature_prey_count = creature_manager.get_final_forest_prey()
	var total_forest_creature_pred_count = creature_manager.get_final_forest_pred()

	var full_gender_forest_amount_male = creature_manager.get_forest_gender(false)
	var full_gender_forest_amount_female = creature_manager.get_forest_gender(true)
		
	var highest_fprey_scores = creature_manager.forest_prey_highest_gen_score()
	var highest_fpred_scores = creature_manager.forest_pred_highest_gen_score()
	var highest_forest_gen_reach = creature_manager.get_forest_gen()

	excel_data += "Forest," +  str(total_forest_creature_count) + "," + str(total_forest_creature_pred_count) + "," + str(total_forest_creature_prey_count) + "," + str(full_gender_forest_amount_female) + "," + str(full_gender_forest_amount_male) + "," + str(highest_forest_gen_reach) + "\n"
	
	excel_data +=  "Higest Generational Scores\n"
	excel_data +=  "Prey, , , , , , ,"
	# Iterate through the results and print them
	for result in highest_fprey_scores:
		
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + "," 

	excel_data +=  "\nPredators, , , , , , ,"
	
	# Iterate through the results and print them
	for result in highest_fpred_scores:
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + ","
	
	excel_data += "\n\n"

	#=================================== Stone ====================================


	var total_stone_creature_count = creature_manager.get_final_stone_creatures()
	var total_stone_creature_prey_count = creature_manager.get_final_stone_prey()
	var total_stone_creature_pred_count = creature_manager.get_final_stone_pred()

	var full_gender_stone_amount_male = creature_manager.get_stone_gender(false)
	var full_gender_stone_amount_female = creature_manager.get_stone_gender(true)

	var highest_sprey_scores = creature_manager.stone_prey_highest_gen_score()
	var highest_spred_scores = creature_manager.stone_pred_highest_gen_score()
	var highest_stone_gen_reach = creature_manager.get_stone_gen()
	
	excel_data += "Stone," +  str(total_stone_creature_count) + "," + str(total_stone_creature_pred_count) + "," + str(total_stone_creature_prey_count) + "," + str(full_gender_stone_amount_female) + "," + str(full_gender_stone_amount_male) + "," + str(highest_stone_gen_reach) + "\n"
	
	excel_data +=  "Higest Generational Scores\n"
	excel_data +=  "Prey, , , , , , ,"
	# Iterate through the results and print them
	for result in highest_sprey_scores:
		
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + "," 

	excel_data +=  "\nPredators, , , , , , ,"
	
	# Iterate through the results and print them
	for result in highest_spred_scores:
		var gen = result[0]
		var highest_score = result[1]
		excel_data += str(highest_score) + ","
	
	excel_data += "\n\n"
	
	save_excel(excel_data)
	
func _process(_delta):
	
	if loaded:
		label.text = "Data Loaded"
	elif loaded == null:
		label.text = "Data Loading"
	else:
		label.text = "Data could not be saved check file location or name"

func save(content):
	
	#print("Save:" ,content)
	if !FileAccess.file_exists("res://Text/Data/Data.txt"):
		var file = FileAccess.open("res://Text/Data/Data.txt", FileAccess.WRITE_READ)
		file.store_string(content)
		loaded = true
	elif !FileAccess.file_exists("res://Text/Data/NewData.txt"):
		var file = FileAccess.open("res://Text/Data/NewData.txt", FileAccess.WRITE_READ)
		file.store_string(content)
		loaded = true
	else:
		loaded = false
		
func save_excel(content):
	
	#print("Save:" ,content)
	if !FileAccess.file_exists("res://Text/Data/Data.csv"):
		var file = FileAccess.open("res://Text/Data/Data.csv", FileAccess.WRITE_READ)
		file.store_string(content)
		loaded = true
	elif !FileAccess.file_exists("res://Text/Data/NewData.csv"):
		var file = FileAccess.open("res://Text/Data/NewData.csv", FileAccess.WRITE_READ)
		file.store_string(content)
		loaded = true
	else:
		loaded = false

func _on_quit_pressed():
	get_tree().quit()
