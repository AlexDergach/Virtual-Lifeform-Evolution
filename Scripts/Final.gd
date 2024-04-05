extends Control

var creature_manager

# Called when the node enters the scene tree for the first time.
func _ready():
	creature_manager = Engine.get_singleton("CreatureManager")
	
		# Call the function to get the highest scores
	var highest_scores = creature_manager.desert_prey_highest_gen_score()

	# Iterate through the results and print them
	for result in highest_scores:
		var gen = result[0]
		var highest_score = result[1]
		print("Generation:", gen, "Highest Score:", highest_score)
	
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_quit_pressed():
	get_tree().quit()
