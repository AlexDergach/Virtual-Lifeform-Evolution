extends Node

# Singleton pattern to ensure only one instance of CreatureManager exists
func _ready():
	if not Engine.has_singleton("CreatureManager"):
		Engine.register_singleton("CreatureManager", self)



#============ Total Creatures ========================
var total_creatures = []
var final_total_creatures = []
var final_total_creatures_male = 0
var final_total_creatures_female = 0

# Add a creature instance to the list
func add_creature(creature):
	total_creatures.append(creature)
	final_total_creatures.append(creature)

# Remove a creature instance from the list
func remove_creature(creature):
	if creature in total_creatures:
		total_creatures.erase(creature)

# Get the total number of creatures
func get_total_creatures():
	return len(total_creatures)
	
# Get the total number of creatures
func get_final_total_creatures():
	return len(final_total_creatures)

func get_creature_gender(choice):
	if choice:
		return final_total_creatures_female
	else:
		return final_total_creatures_male


#============ Desert Creatures ========================


var total_desert_creatures = []
var total_final_desert_creatures = []
var highest_desert_gen
var starting_gen
var previous_gen
var total_desert_prey = []
var total_final_desert_prey = []
var total_desert_pred = []
var total_final_desert_pred = []



	
# Add a creature instance to the list
func add_desert_creature(creature):
	total_desert_creatures.append(creature)
	total_final_desert_creatures.append(creature)

# Remove a creature instance from the list
func remove_desert_creature(creature):
	if creature in total_desert_creatures:
		total_desert_creatures.erase(creature)

# Get the total number of creatures
func get_desert_creature():
	return len(total_desert_creatures)
	
# Get the total number of creatures
func get_final_desert_creatures():
	return len(total_final_desert_creatures)
	
	
func add_desert_gen(gen):
	if gen == 0:
		starting_gen = gen
		previous_gen = starting_gen
		highest_desert_gen = gen
	else:
		if previous_gen < gen:
			print("Setting gen to:", gen ," The Previous gen was: ", previous_gen)
			highest_desert_gen = gen
			previous_gen = gen

func get_desert_gen():
	return highest_desert_gen

#=============== Desert Prey Gen ======================


var desert_prey_gen = []

func desert_prey_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(desert_prey_gen) <= gen:
		desert_prey_gen.resize(gen + 1)
		print("Generation added", gen)
		desert_prey_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	desert_prey_gen[gen].append(average)
	
var highest_desert_prey_scores = []
	
func desert_prey_highest_gen_score():
	highest_desert_prey_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(desert_prey_gen.size()):
		var gen_scores = desert_prey_gen[gen]
		#print("PRey Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_desert_prey_scores.append([gen, highest_score])

	return highest_desert_prey_scores

#============ Desert Prey ========================


# Add a creature instance to the list
func add_desert_prey(creature):
	total_desert_prey.append(creature)
	total_final_desert_creatures.append(creature)

# Remove a creature instance from the list
func remove_desert_prey(creature):
	if creature in total_desert_prey:
		total_desert_prey.erase(creature)

# Get the total number of creatures
func get_desert_prey():
	return len(total_desert_prey)
	
# Get the total number of creatures
func get_final_desert_prey():
	return len(total_final_desert_prey)


#============ Desert Pred ========================

# Add a creature instance to the list
func add_desert_pred(creature):
	total_desert_pred.append(creature)
	total_final_desert_pred.append(creature)

# Remove a creature instance from the list
func remove_desert_pred(creature):
	if creature in total_desert_pred:
		total_desert_pred.erase(creature)

# Get the total number of creatures
func get_desert_pred():
	return len(total_desert_pred)

# Get the total number of creatures
func get_final_desert_pred():
	return len(total_final_desert_pred)
	
#======= Desert Gender =======
	
	
var total_desert_gender_male = 0
var total_desert_gender_female = 0
var total_desert_pred_male = 0
var total_desert_pred_female = 0
var total_desert_prey_male = 0
var total_desert_prey_female = 0
	
func add_desert_pred_gender(gender):
	if gender == true:
		total_desert_pred_female += 1
		total_desert_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_desert_pred_male += 1
		total_desert_gender_male += 1
		final_total_creatures_male += 1
		
func add_desert_prey_gender(gender):
	if gender == true:
		total_desert_prey_female += 1
		total_desert_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_desert_prey_male += 1
		total_desert_gender_male += 1
		final_total_creatures_male += 1

func get_desert_gender(choice):
	if choice:
		return total_desert_gender_female
	else:
		return total_desert_gender_male
		
func get_desert_pred_gender(choice):
	if choice:
		return total_desert_pred_female
	else: 
		return total_desert_pred_male

func get_desert_prey_gender(choice):
	if choice:
		return total_desert_prey_female
	else: 
		return total_desert_prey_male
		
#=================== Desert Pred Gen ==========================

var desert_pred_gen = []

func desert_pred_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(desert_pred_gen) <= gen:
		desert_pred_gen.resize(gen + 1)
		#print("Generation added", gen)
		desert_pred_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	desert_pred_gen[gen].append(average)
	
var highest_desert_pred_scores = []
	
func desert_pred_highest_gen_score():
	highest_desert_pred_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(desert_pred_gen.size()):
		var gen_scores = desert_pred_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_desert_pred_scores.append([gen, highest_score])

	return highest_desert_pred_scores


#============ Ice Creatures ========================



var total_ice_creatures = []
var highest_ice_gen
var starting_ice_gen
var previous_ice_gen
var total_ice_prey = []


	
# Add a creature instance to the list
func add_ice_creature(creature):
	total_ice_creatures.append(creature)

# Remove a creature instance from the list
func remove_ice_creature(creature):
	if creature in total_ice_creatures:
		total_ice_creatures.erase(creature)

# Get the total number of creatures
func get_ice_creature():
	return len(total_ice_creatures)
	
func add_ice_gen(gen):

	if gen == 0:
		starting_ice_gen = gen
		previous_ice_gen = starting_ice_gen
		highest_ice_gen = gen
	else:
		if previous_ice_gen < gen:
			highest_ice_gen = gen

func get_ice_gen():
	return highest_ice_gen
#============ Ice Prey ========================

# Add a creature instance to the list
func add_ice_prey(creature):
	total_ice_prey.append(creature)

# Remove a creature instance from the list
func remove_ice_prey(creature):
	if creature in total_ice_prey:
		total_ice_prey.erase(creature)

# Get the total number of creatures
func get_ice_prey():
	return len(total_ice_prey)



#============== Ice Gender ================

var total_ice_gender_male = 0
var total_ice_gender_female = 0
	
func add_ice_gender(gender):
	if gender == true:
		total_ice_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_ice_gender_male += 1
		final_total_creatures_male += 1

func get_ice_gender(choice):
	if choice:
		return total_ice_gender_female
	else:
		return total_ice_gender_male


#=================== Ice Prey Gen ==========================

var ice_prey_gen = []

func ice_prey_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(ice_prey_gen) <= gen:
		ice_prey_gen.resize(gen + 1)
		#print("Generation added", gen)
		ice_prey_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	ice_prey_gen[gen].append(average)
	
var highest_ice_prey_scores = []
	
func ice_prey_highest_gen_score():
	highest_ice_prey_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(ice_prey_gen.size()):
		var gen_scores = ice_prey_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_ice_prey_scores.append([gen, highest_score])

	return highest_ice_prey_scores



#============ Forest Creatures ========================

var total_forest_creatures = []
var highest_forest_gen
var starting_forest_gen
var previous_forest_gen
var total_forest_prey = []
var total_forest_pred = []


# Add a creature instance to the list
func add_forest_creature(creature):
	total_forest_creatures.append(creature)

# Remove a creature instance from the list
func remove_forest_creature(creature):
	if creature in total_forest_creatures:
		total_forest_creatures.erase(creature)

# Get the total number of creatures
func get_forest_creature():
	return len(total_forest_creatures)

func add_forest_gen(gen):

	if gen == 0:
		starting_forest_gen = gen
		previous_forest_gen = starting_forest_gen
		highest_forest_gen = gen
	else:
		if previous_forest_gen < gen:
			highest_forest_gen = gen
			
func get_forest_gen():
	return highest_forest_gen

#============ Forest Prey ========================

# Add a creature instance to the list
func add_forest_prey(creature):
	total_forest_prey.append(creature)

# Remove a creature instance from the list
func remove_forest_prey(creature):
	if creature in total_forest_prey:
		total_forest_prey.erase(creature)

# Get the total number of creatures
func get_forest_prey():
	return len(total_forest_prey)

#============ Forest Pred ========================

# Add a creature instance to the list
func add_forest_pred(creature):
	total_forest_pred.append(creature)

# Remove a creature instance from the list
func remove_forest_pred(creature):
	if creature in total_forest_pred:
		total_forest_pred.erase(creature)

# Get the total number of creatures
func get_forest_pred():
	return len(total_forest_pred)


#============ Forest Gender ===============

var total_forest_gender_male = 0
var total_forest_gender_female = 0
var total_forest_pred_male = 0
var total_forest_pred_female = 0
var total_forest_prey_male = 0
var total_forest_prey_female = 0
	
func add_forest_pred_gender(gender):
	if gender == true:
		total_forest_pred_female += 1
		total_forest_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_forest_pred_male += 1
		total_forest_gender_male += 1
		final_total_creatures_male += 1
		
func add_forest_prey_gender(gender):
	if gender == true:
		total_forest_prey_female += 1
		total_forest_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_forest_prey_male += 1
		total_forest_gender_male += 1
		final_total_creatures_male += 1

func get_forest_gender(choice):
	if choice:
		return total_forest_gender_female
	else:
		return total_forest_gender_male
		
func get_forest_pred_gender(choice):
	if choice:
		return total_forest_pred_female
	else: 
		return total_forest_pred_male

func get_forest_prey_gender(choice):
	if choice:
		return total_forest_prey_female
	else: 
		return total_forest_prey_male

#=================== Forest Prey Gen ==========================

var forest_prey_gen = []

func forest_prey_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(forest_prey_gen) <= gen:
		forest_prey_gen.resize(gen + 1)
		#print("Generation added", gen)
		forest_prey_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	forest_prey_gen[gen].append(average)
	
var highest_forest_prey_scores = []
	
func forest_prey_highest_gen_score():
	highest_forest_prey_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(forest_prey_gen.size()):
		var gen_scores = forest_prey_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_forest_prey_scores.append([gen, highest_score])

	return highest_forest_prey_scores

#=================== Forest Pred Gen ==========================

var forest_pred_gen = []

func forest_pred_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(forest_pred_gen) <= gen:
		forest_pred_gen.resize(gen + 1)
		#print("Generation added", gen)
		forest_pred_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	forest_pred_gen[gen].append(average)
	
var highest_forest_pred_scores = []
	
func forest_pred_highest_gen_score():
	highest_forest_pred_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(forest_pred_gen.size()):
		var gen_scores = forest_pred_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_forest_pred_scores.append([gen, highest_score])

	return highest_forest_pred_scores





#============ Fire Creatures ========================

var total_fire_creatures = []
var highest_fire_gen
var starting_fire_gen
var previous_fire_gen
var total_fire_prey = []
var total_fire_pred = []


# Add a creature instance to the list
func add_fire_creature(creature):
	total_fire_creatures.append(creature)

# Remove a creature instance from the list
func remove_fire_creature(creature):
	if creature in total_fire_creatures:
		total_fire_creatures.erase(creature)

# Get the total number of creatures
func get_fire_creature():
	return len(total_fire_creatures)

func add_fire_gen(gen):


	if gen == 0:
		starting_fire_gen = gen
		previous_fire_gen = starting_fire_gen
		highest_fire_gen = gen
	else:
		if previous_fire_gen < gen:
			highest_fire_gen = gen

func get_fire_gen():
	return highest_fire_gen

#============ Fire Prey ========================

# Add a creature instance to the list
func add_fire_prey(creature):
	total_fire_prey.append(creature)

# Remove a creature instance from the list
func remove_fire_prey(creature):
	if creature in total_fire_prey:
		total_fire_prey.erase(creature)

# Get the total number of creatures
func get_fire_prey():
	return len(total_fire_prey)

#============ Fire Pred ========================

# Add a creature instance to the list
func add_fire_pred(creature):
	total_fire_pred.append(creature)

# Remove a creature instance from the list
func remove_fire_pred(creature):
	if creature in total_fire_pred:
		total_fire_pred.erase(creature)

# Get the total number of creatures
func get_fire_pred():
	return len(total_fire_pred)



#============ Fire Gender ===============

var total_fire_gender_male = 0
var total_fire_gender_female = 0
var total_fire_pred_male = 0
var total_fire_pred_female = 0
var total_fire_prey_male = 0
var total_fire_prey_female = 0
	
func add_fire_pred_gender(gender):
	if gender == true:
		total_fire_pred_female += 1
		total_fire_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_fire_pred_male += 1
		total_fire_gender_male += 1
		final_total_creatures_male += 1
		
func add_fire_prey_gender(gender):
	if gender == true:
		total_fire_prey_female += 1
		total_fire_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_fire_prey_male += 1
		total_fire_gender_male += 1
		final_total_creatures_male += 1

func get_fire_gender(choice):
	if choice:
		return total_fire_gender_female
	else:
		return total_fire_gender_male
		
func get_fire_pred_gender(choice):
	if choice:
		return total_fire_pred_female
	else: 
		return total_fire_pred_male

func get_fire_prey_gender(choice):
	if choice:
		return total_fire_prey_female
	else: 
		return total_fire_prey_male


#=================== Fire Prey Gen ==========================

var fire_prey_gen = []

func fire_prey_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(fire_prey_gen) <= gen:
		fire_prey_gen.resize(gen + 1)
		#print("Generation added", gen)
		fire_prey_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	fire_prey_gen[gen].append(average)
	
var highest_fire_prey_scores = []
	
func fire_prey_highest_gen_score():
	highest_fire_prey_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(fire_prey_gen.size()):
		var gen_scores = fire_prey_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_fire_prey_scores.append([gen, highest_score])

	return highest_fire_prey_scores

#=================== Fire Pred Gen ==========================

var fire_pred_gen = []

func fire_pred_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(fire_pred_gen) <= gen:
		fire_pred_gen.resize(gen + 1)
		#print("Generation added", gen)
		fire_pred_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	fire_pred_gen[gen].append(average)
	
var highest_fire_pred_scores = []
	
func fire_pred_highest_gen_score():
	highest_fire_pred_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(fire_pred_gen.size()):
		var gen_scores = fire_pred_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_fire_pred_scores.append([gen, highest_score])

	return highest_fire_pred_scores






#============ Stone Creatures ========================


var total_stone_creatures = []
var highest_stone_gen
var starting_stone_gen
var previous_stone_gen
var total_stone_prey = []
var total_stone_pred = []


# Add a creature instance to the list
func add_stone_creature(creature):
	total_stone_creatures.append(creature)

# Remove a creature instance from the list
func remove_stone_creature(creature):
	if creature in total_stone_creatures:
		total_stone_creatures.erase(creature)

# Get the total number of creatures
func get_stone_creature():
	return len(total_stone_creatures)

func add_stone_gen(gen):
	

	if gen == 0:
		starting_stone_gen = gen
		previous_stone_gen = starting_stone_gen
		highest_stone_gen = gen
	else:
		if previous_stone_gen < gen:
			highest_stone_gen = gen

func get_stone_gen():
	return highest_stone_gen
#============ Stone Prey ========================

# Add a creature instance to the list
func add_stone_prey(creature):
	total_stone_prey.append(creature)

# Remove a creature instance from the list
func remove_stone_prey(creature):
	if creature in total_stone_prey:
		total_stone_prey.erase(creature)

# Get the total number of creatures
func get_stone_prey():
	return len(total_stone_prey)

#============ Stone Pred ========================

# Add a creature instance to the list
func add_stone_pred(creature):
	total_stone_pred.append(creature)

# Remove a creature instance from the list
func remove_stone_pred(creature):
	if creature in total_stone_pred:
		total_stone_pred.erase(creature)

# Get the total number of creatures
func get_stone_pred():
	return len(total_stone_pred)


#============ Stone Gender ===============

var total_stone_gender_male = 0
var total_stone_gender_female = 0
var total_stone_pred_male = 0
var total_stone_pred_female = 0
var total_stone_prey_male = 0
var total_stone_prey_female = 0
	
func add_stone_pred_gender(gender):
	if gender == true:
		total_stone_pred_female += 1
		total_stone_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_stone_pred_male += 1
		total_stone_gender_male += 1
		final_total_creatures_male += 1
		
func add_stone_prey_gender(gender):
	if gender == true:
		total_stone_prey_female += 1
		total_stone_gender_female += 1
		final_total_creatures_female += 1
	else:
		total_stone_prey_male += 1
		total_stone_gender_male += 1
		final_total_creatures_male += 1

func get_stone_gender(choice):
	if choice:
		return total_stone_gender_female
	else:
		return total_stone_gender_male
		
func get_stone_pred_gender(choice):
	if choice:
		return total_stone_pred_female
	else: 
		return total_stone_pred_male

func get_stone_prey_gender(choice):
	if choice:
		return total_stone_prey_female
	else: 
		return total_stone_prey_male
		
		
		
#=================== Stone Prey Gen ==========================

var stone_prey_gen = []

func stone_prey_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(stone_prey_gen) <= gen:
		stone_prey_gen.resize(gen + 1)
		#print("Generation added", gen)
		stone_prey_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	stone_prey_gen[gen].append(average)
	
var highest_stone_prey_scores = []
	
func stone_prey_highest_gen_score():
	highest_stone_prey_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(stone_prey_gen.size()):
		var gen_scores = stone_prey_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_stone_prey_scores.append([gen, highest_score])

	return highest_stone_prey_scores

#=================== Stone Pred Gen ==========================

var stone_pred_gen = []

func stone_pred_gen_score(average, gen):
	# If the generation is not yet added, initialize it as an empty array
	if len(stone_pred_gen) <= gen:
		stone_pred_gen.resize(gen + 1)
		#print("Generation added", gen)
		stone_pred_gen[gen] = []  # Initialize the generation array
	# Append the average score to the corresponding generation
	stone_pred_gen[gen].append(average)
	
var highest_stone_pred_scores = []
	
func stone_pred_highest_gen_score():
	highest_stone_pred_scores.clear()  # Clear the previous scores

	# Iterate through each generation
	for gen in range(stone_pred_gen.size()):
		var gen_scores = stone_pred_gen[gen]
		#print("Pred Gen scores, ",gen_scores)
		var highest_score = 0
		# Find the highest average score for the current generation
		for score in gen_scores:
			if score > highest_score:
				highest_score = score
		highest_stone_pred_scores.append([gen, highest_score])

	return highest_stone_pred_scores
