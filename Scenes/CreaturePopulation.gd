extends Node

# Singleton pattern to ensure only one instance of CreatureManager exists
func _ready():
	if not Engine.has_singleton("CreatureManager"):
		Engine.register_singleton("CreatureManager", self)


# List to store references to all creature instances
var creatures = []
var test = 1

func get_test():
	return test

# Add a creature instance to the list
func add_creature(creature):
	creatures.append(creature)

# Remove a creature instance from the list
func remove_creature(creature):
	if creature in creatures:
		creatures.erase(creature)

# Get the total number of creatures
func get_total_creatures():
	return len(creatures)
