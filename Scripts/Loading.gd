extends Control

var progress = []
var sceneName
var scene_load_status = 0

@onready var progressbar = $ProgressBar

func _ready():
	sceneName = "res://MainMap.tscn"
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	progressbar.value = floor(progress[0]*100)
	if scene_load_status == ResourceLoader.THREAD_LOAD_LOADED:
		var newScene = ResourceLoader.load_threaded_get(sceneName)
		get_tree().change_scene_to_packed(newScene)
