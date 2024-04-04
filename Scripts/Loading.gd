extends Control

var sceneName = "res://MainMap.tscn"
var scene_load_status = 0
var progress = []

@onready var progressbar = $ProgressBar

func _ready():
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	match scene_load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress.size() > 0:
				progressbar.value = floor(progress[0] * 100)
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Scene loading failed!")
		ResourceLoader.THREAD_LOAD_LOADED:
			var newScene = ResourceLoader.load_threaded_get(sceneName)
			get_tree().change_scene_to_packed(newScene)
