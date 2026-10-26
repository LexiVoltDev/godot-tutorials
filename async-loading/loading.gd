extends Control

# 1. Point the loading screen at the scene you want next.
@export_file("*.tscn") var next_scene_path := "res://level.tscn"
@export var bar_speed := 1.5

@onready var bar: ProgressBar = $ProgressBar
@onready var spinner: Control = $Spinner

var _progress := []
var _shown := 0.0


# 2. Start loading on a background thread. This line returns right away.
func _ready() -> void:
	ResourceLoader.load_threaded_request(next_scene_path)


func _process(delta: float) -> void:
	spinner.rotation += 5.0 * delta
	# 3. Ask how it is going. Godot writes the progress, 0 to 1, into _progress[0].
	var status := ResourceLoader.load_threaded_get_status(next_scene_path, _progress)
	if status == ResourceLoader.THREAD_LOAD_FAILED or status == ResourceLoader.THREAD_LOAD_INVALID_RESOURCE:
		push_error("Could not load " + next_scene_path)
		set_process(false)
		return
	# 4. Ease the bar toward the real number so it glides instead of jumping.
	_shown = move_toward(_shown, _progress[0], bar_speed * delta)
	bar.value = _shown * 100.0
	# 5. Loaded and the bar is full: only now grab the scene. This call will not block.
	if status == ResourceLoader.THREAD_LOAD_LOADED and is_equal_approx(_shown, 1.0):
		set_process(false)
		get_tree().change_scene_to_packed(ResourceLoader.load_threaded_get(next_scene_path))
