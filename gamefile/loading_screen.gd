extends Control

var next_scene_path = "res://cafe.tscn"
var progress = []

func _ready():
	ResourceLoader.load_threaded_request(next_scene_path)

func _process(_delta):
	var status = ResourceLoader.load_threaded_get_status(next_scene_path, progress)
	
	if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
		$ProgressBar.value = progress[0] * 100
	
	elif status == ResourceLoader.THREAD_LOAD_LOADED:
		var next_scene = ResourceLoader.load_threaded_get(next_scene_path)
		get_tree().change_scene_to_packed(next_scene)
		Global.cafe_area = true
