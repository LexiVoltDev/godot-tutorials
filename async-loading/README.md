# Async Loading Screen: a progress bar that never freezes (Godot 4.8 beta 1)

From the Lexi Volt Godot tutorial on threaded loading with `ResourceLoader.load_threaded_request`. Video coming soon.

## What it shows

A loading screen that keeps drawing while a heavy level (20,000 stars) loads on a background
thread. The cyan square keeps spinning, the bar glides from 0 to 100 instead of jumping, and the
starfield appears when it's done. Plain `load()` would freeze the whole screen for about a second.

## Godot version

Tested on **Godot 4.8 beta 1** (4.8.beta1.official.4d10419ca), Compatibility renderer, and on
4.7-stable. Threaded loading is plain Godot 4 API, nothing here is beta-only. 4.8 is a beta, so
details like the exact progress steps can still change between builds.

## How to run

1. Open Godot 4.8 beta 1 (or any recent Godot 4).
2. In the Project Manager, click **Import** and pick `async-loading/project.godot`.
3. Press **Play** (F5). The loading screen runs first, then the level shows up.

Try it: select the **Loading** node, set **Bar Speed** to 100 in the Inspector and press Play
again. The bar stutters, then snaps to full. Set it back to 1.5.

## Files

- `loading.gd`: the whole loading screen (steps 1 to 5 in the video).
- `loading.tscn`: Loading (Control) with Background, Title, Spinner and ProgressBar. Main scene.
- `level.tscn` + `chunks/chunk_0..9.tscn`: the heavy level, 10 chunks of 2,000 stars each. It's
  big on purpose (about 6 MB of text scenes) so the load takes long enough to see.
- `tools/make_level.gd`: rebuilds the level. From the project folder:
  `godot --headless --path . -s res://tools/make_level.gd`. Raise `CHUNKS` if your machine
  loads it too fast to see.

## The code

```gdscript
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
```

## Good to know

- Don't call `load_threaded_get` before the status says loaded. It waits for the whole load,
  so the game freezes just like plain `load()`.
- The load is threaded, but the scene swap isn't. `change_scene_to_packed` still builds all
  20,000 nodes on the main thread, a fraction of a second. Cover it with a fade if it shows.
- A typo in the path won't crash. The load fails quietly and progress still reports 1, so keep
  the `THREAD_LOAD_FAILED` check or the bar fills up and waits forever.

## Credits & licenses

No third-party assets. All visuals are generated in-engine (ColorRects, Polygon2D stars and the
default theme); no fonts, images or audio. Code and scenes: Lexi Volt, MIT (see the repo
[LICENSE](../LICENSE)).
