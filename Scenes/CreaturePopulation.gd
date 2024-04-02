extends Node

# Singleton pattern to ensure only one instance of CreatureManager exists
func _ready():
	if not Engine.has_singleton("CreatureManager"):
		Engine.register_singleton("CreatureManager", self)

# List to store references to all creature instances
var total_creatures = []

#============ Total Creatures ========================

# Add a creature instance to the list
func add_creature(creature):
	total_creatures.append(creature)

# Remove a creature instance from the list
func remove_creature(creature):
	if creature in total_creatures:
		total_creatures.erase(creature)

# Get the total number of creatures
func get_total_creatures():
	return len(total_creatures)


var total_desert_creatures = []
var total_desert_prey = []
var total_desert_pred = []

#============ Desert Creatures ========================
	
# Add a creature instance to the list
func add_desert_creature(creature):
	total_desert_creatures.append(creature)

# Remove a creature instance from the list
func remove_desert_creature(creature):
	if creature in total_desert_creatures:
		total_desert_creatures.erase(creature)

# Get the total number of creatures
func get_desert_creature():
	return len(total_desert_creatures)

#============ Desert Prey ========================

# Add a creature instance to the list
func add_desert_prey(creature):
	total_desert_prey.append(creature)

# Remove a creature instance from the list
func remove_desert_prey(creature):
	if creature in total_desert_prey:
		total_desert_prey.erase(creature)

# Get the total number of creatures
func get_desert_prey():
	return len(total_desert_prey)

#============ Desert Pred ========================

# Add a creature instance to the list
func add_desert_pred(creature):
	total_desert_pred.append(creature)

# Remove a creature instance from the list
func remove_desert_pred(creature):
	if creature in total_desert_pred:
		total_desert_pred.erase(creature)

# Get the total number of creatures
func get_desert_pred():
	return len(total_desert_pred)


var total_ice_creatures = []
var total_ice_prey = []


#============ Ice Creatures ========================
	
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


var total_forest_creatures = []
var total_forest_prey = []
var total_forest_pred = []

#============ Forest Creatures ========================
	
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



var total_fire_creatures = []
var total_fire_prey = []
var total_fire_pred = []

#============ Fire Creatures ========================
	
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



var total_stone_creatures = []
var total_stone_prey = []
var total_stone_pred = []


#============ Stone Creatures ========================
	
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


