extends Control

func _ready():
	pass

func _process(delta):
	pass

func _on_quit_pressed():
	get_tree().quit()

func _on_play_pressed():
	get_tree().change_scene_to_file("res://UI/Loading.tscn")

