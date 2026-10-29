# Live Editing: keep your Game view edits with one key (Godot 4.8 beta 1)

From the Lexi Volt Godot tutorial "Godot 4.8 Level Design: Edit Your Level While It Runs". Video coming soon.

Project folder: https://github.com/LexiVoltDev/godot-tutorials/tree/main/live-editing

## What it shows

In Godot 4.8 beta 1 you can move, rotate and scale 2D nodes in the Game view while the game is
running, but those edits are gone the moment you stop. `keep_edits.gd` is a small debug autoload:
press **K** and it packs the running level, live edits and all, and saves a copy next to it as
`level_tuned.tscn`. Your original `level.tscn` is never touched.

## Godot version

Tested on **Godot 4.8 beta 1** (4.8.beta1.official.4d10419ca), Compatibility renderer. Editing
2D nodes in the Game view is new in 4.8 beta 1 and only works for 2D nodes for now, so the UI
can still change between betas. The keep script itself is plain Godot 4 API
(`PackedScene.pack` + `ResourceSaver.save`) and also runs on 4.7-stable.

## How to run

1. Open Godot 4.8 beta 1.
2. In the Project Manager, click **Import** and pick `live-editing/project.godot`.
3. Press **Play** (F5). The game runs inside the editor's **Game** tab.
4. In the Game view toolbar, click **2D**. Game input switches off, so clicks pick nodes.
   Select the Platform, pick **Move Mode** (W) and drag it. Select the Wall, pick
   **Rotate Mode** (E) and tilt it. Ctrl+Z (mouse over the Game view) undoes each edit.
5. Click **Input** so the game hears keys again, then press **K**. The Output panel prints
   `Kept your edits in res://level_tuned.tscn`.
6. Click into the FileSystem dock so it refreshes, then open `level_tuned.tscn`.

Try it: the coins are missing from the tuned file. In `level.gd`, add `coin.owner = self` after
`add_child(coin)`, run again and press K. Now the coins are saved too.

## Files

- `keep_edits.gd`: the whole keep script (steps 1 to 4 in the video). Autoload `KeepEdits`.
- `level.tscn`: the demo level (Sky, Ground with a solid Floor, Platform, Platform2, Wall, Goal). Main scene.
- `level.gd`: spawns three coins at runtime with no owner, so `pack` leaves them out.
- `project.godot`: 1152x648, Compatibility renderer, autoload already set up.

## The code

```gdscript
extends Node
# Debug helper for live editing in the Game view (Godot 4.8 beta 1).
# Add it as an autoload: Project Settings, Globals, Autoload.

# 1. Pick one key. K for "keep".
const KEEP_KEY := KEY_K


func _unhandled_key_input(event: InputEvent) -> void:
	# 2. Only listen in debug runs, so the shipped game never writes files.
	if not OS.is_debug_build():
		return
	var key := event as InputEventKey
	if key and key.pressed and not key.echo and key.keycode == KEEP_KEY:
		keep_edits()


func keep_edits() -> String:
	# 3. Grab the running level, live edits and all, and pack it.
	var level := get_tree().current_scene
	var packed := PackedScene.new()
	var err := packed.pack(level)
	if err != OK:
		push_error("Pack failed: %s" % error_string(err))
		return ""
	# 4. Save a copy next to the original, never over it.
	var path := level.scene_file_path.get_basename() + "_tuned.tscn"
	err = ResourceSaver.save(packed, path)
	if err != OK:
		push_error("Save failed: %s" % error_string(err))
		return ""
	print("Kept your edits in ", path)
	return path
```

## Good to know

- `pack` only keeps nodes whose `owner` is the level. Nodes from the scene file have it; nodes
  you `add_child` in code don't, unless you set `owner` yourself. That keeps bullets and
  particles out of your level.
- In 2D mode the game gets no input, so K does nothing. Click **Input** first.
- Physics bodies: drag a RigidBody2D and physics takes over the moment you let go. Press **F9**
  (Suspend/Resume Embedded Game; Cmd+Shift+B on macOS) to suspend the whole game, place it,
  press F9 again to resume, then click Input and press K. To grab the body rather than its
  sprite, Alt+right-click it and pick it from the list, then drag in Move Mode.
- It's a copy. Open `level_tuned.tscn`, check it, and swap it in yourself.
- K only works in debug runs (`OS.is_debug_build()`), so an exported game never writes files.

## Credits & licenses

No third-party assets. All visuals are generated in-engine (Polygon2D, ColorRect, Label and the
default theme); no fonts, images or audio. Code and scenes: Lexi Volt, MIT (see the repo
[LICENSE](../LICENSE)).
