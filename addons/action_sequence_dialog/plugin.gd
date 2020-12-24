tool
extends EditorPlugin

var additional_mains = []
var editor_selection
var action_sequence
var pop_add
var pop_sequence

func _enter_tree():
	# SIGNAL CONNECTIONS
	connect("scene_changed", self, "_on_scene_changed")
	editor_selection = get_editor_interface().get_selection()
	editor_selection.connect("selection_changed", self, "_on_selection_changed")
	
	# ADD TO MAIN TOOLBAR
	#	ADD EVENT
	var add_event = ToolButton.new()
	add_event.set_button_icon(load("res://addons/action_sequence_dialog/additional_toolbar/add_event.svg"))
	add_event.connect("pressed", self, "_on_add_event_pressed")
	
	#	ACION SEQUENCE
	action_sequence = ToolButton.new()
	action_sequence.set_button_icon(load("res://addons/action_sequence_dialog/additional_toolbar/action_squence.svg"))
	action_sequence.set_disabled(true)
	action_sequence.connect("pressed", self, "_on_action_sequence_pressed")
	
	additional_mains += [VSeparator.new(), add_event, action_sequence]
	for c in additional_mains:
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, c)
		
	# POPUPS
	var behind_popups = get_script_create_dialog().get_parent()
	
	pop_add = load("res://addons/action_sequence_dialog/popup/AddEvent.tscn").instance()
	pop_add.set_as_minsize()
	behind_popups.add_child(pop_add)
	
	pop_sequence = load("res://addons/action_sequence_dialog/popup/ActionSequence.tscn").instance()
	pop_sequence.set_as_minsize()
	behind_popups.add_child(pop_sequence)
	
func _exit_tree():
	for c in additional_mains:
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, c)
		c.queue_free()
	
	disconnect("scene_changed", self, "_on_scene_changed")
	editor_selection.disconnect("selection_changed", self, "_on_selection_changed")

func _on_scene_changed(new_root):
	var root_is_Overworld = new_root != null and new_root is Overworld
	
	for c in additional_mains:
		c.set_visible(root_is_Overworld)

func _on_selection_changed():
	for n in editor_selection.get_selected_nodes():
		if n is Event:
			action_sequence.set_disabled(false)
			return
	action_sequence.set_disabled(true)

func _on_add_event_pressed():
	pop_add.popup_centered()

func _on_action_sequence_pressed():
	pop_sequence.popup_centered()
