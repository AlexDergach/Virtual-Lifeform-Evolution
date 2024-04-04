extends Control

var spawn_size

func _ready():
	if not Engine.has_singleton("Start"):
		Engine.register_singleton("Start", self)
		
func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	if get_spawn_size() != null :
		get_tree().change_scene_to_file("res://UI/Loading.tscn")

func _on_options_item_selected(index):
	Start.spawn_size = index
	spawn_size = index

func get_spawn_size():
	return spawn_size
