extends Control

var game_path = "res://scenes/game_main.tscn"
var loading = false
var progress = []

# Called when the node enters the scene tree for the first time.
func _ready():
	$Menu.play_pressed.connect(on_play)
	$ProgressBar.hide()

func _process(delta):
	if loading:
		var status = ResourceLoader.load_threaded_get_status(game_path, progress)
		if status == ResourceLoader.THREAD_LOAD_IN_PROGRESS:
			$ProgressBar.value = progress[0] * 100
		elif status == ResourceLoader.THREAD_LOAD_LOADED:
			get_tree().change_scene_to_file(game_path)

func on_play():
	ResourceLoader.load_threaded_request(game_path,"", true)
	loading = true
	$ProgressBar.show()
