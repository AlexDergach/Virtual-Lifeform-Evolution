extends Control

var sceneName = "res://MainMap.tscn"
var scene_load_status = 0
var progress = [0.0]

@onready var progressbar = $ProgressBar

func _ready():
	print("Loading scene asynchronously...")
	ResourceLoader.load_threaded_request(sceneName)

func _process(delta):
	scene_load_status = ResourceLoader.load_threaded_get_status(sceneName, progress)
	print("Scene load status:", scene_load_status)
	match scene_load_status:
		ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			if progress.size() > 0:
				progressbar.value = clamp(progress[0] * 100, 0, 100) * 2
		ResourceLoader.THREAD_LOAD_FAILED:
			print("Scene loading failed!")
		ResourceLoader.THREAD_LOAD_LOADED:
			print("Scene loaded successfully!")
			progressbar.value = 100  # Set progress bar to 100% when scene is loaded
			if progressbar.value == 100:
				var newScene = ResourceLoader.load_threaded_get(sceneName)
				get_tree().change_scene_to_packed(newScene)
