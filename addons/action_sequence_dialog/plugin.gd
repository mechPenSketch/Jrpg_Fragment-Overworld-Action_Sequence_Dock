tool
extends EditorPlugin

var editor_selection
var dock

func _enter_tree():
	# SIGNAL CONNECTIONS
	editor_selection = get_editor_interface().get_selection()
	editor_selection.connect("selection_changed", self, "_on_selection_changed")
	
	# ADD TO DOCK
	dock = load("res://addons/action_sequence_dialog/Dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	switch_dock_display(false)

func _exit_tree():
	# REMOVE FROM DOCK
	remove_control_from_docks(dock)
	dock.free()

func _on_selection_changed():
	for n in editor_selection.get_selected_nodes():
		if n is Event:
			switch_dock_display(true)
			return
	switch_dock_display(false)

func switch_dock_display(b:bool):
	dock.get_child(0).set_visible(!b)
	dock.get_child(1).set_visible(b)
