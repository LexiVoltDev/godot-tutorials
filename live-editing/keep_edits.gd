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
