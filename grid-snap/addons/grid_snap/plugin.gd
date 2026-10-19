# plugin.gd: one dock button that snaps selected Node2Ds to a 16 px grid.
# 1. Named by plugin.cfg. Must be @tool and extend EditorPlugin.
@tool
extends EditorPlugin

const GRID := 16

var dock: EditorDock


func _enter_tree() -> void:
	# 2. Build the dock and add it to the top-right slot.
	dock = EditorDock.new()
	dock.title = "Grid Snap"
	dock.default_slot = EditorDock.DOCK_SLOT_RIGHT_UL
	var button := Button.new()
	button.text = "Snap selection to grid"
	button.pressed.connect(_snap_selection)
	dock.add_child(button)
	add_dock(dock)


func _snap_selection() -> void:
	# 3. Read the nodes selected in the editor.
	var selected: Array[Node] = EditorInterface.get_selection().get_selected_nodes()
	# 4. One undo action, so Ctrl+Z restores every node.
	var ur := get_undo_redo()
	ur.create_action("Snap to grid")
	for node: Node in selected:
		if node is Node2D:
			var target := node as Node2D
			ur.add_do_property(target, "position", target.position.snapped(Vector2(GRID, GRID)))
			ur.add_undo_property(target, "position", target.position)
	ur.commit_action()


func _exit_tree() -> void:
	# 5. Remove and free the dock, or toggling the plugin duplicates it.
	remove_dock(dock)
	dock.queue_free()
	dock = null
