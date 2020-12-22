tool
extends EditorPlugin

var additional_mains = []

func _enter_tree():
	connect("scene_changed", self, "_on_scene_changed")
	
	# ADD TO MAIN TOOLBAR
	#	ADD EVENT
	var add_event = ToolButton.new()
	add_event.set_button_icon(load("res://addons/action_sequence_dialog/additional_toolbar/add_event.svg"))
	add_event.connect("pressed", self, "_on_add_event_pressed")
	
	#	ACION SEQUENCE
	var action_sequence = ToolButton.new()
	action_sequence.set_button_icon(load("res://addons/action_sequence_dialog/additional_toolbar/action_squence.svg"))
	action_sequence.connect("pressed", self, "_on_action_sequence_pressed")
	
	additional_mains += [VSeparator.new(), add_event, action_sequence]
	for c in additional_mains:
		add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, c)

func _exit_tree():
	for c in additional_mains:
		remove_control_from_container(CONTAINER_CANVAS_EDITOR_MENU, c)
		c.queue_free()
	
	disconnect("scene_changed", self, "_on_scene_changed")

func _on_scene_changed(new_root):
	var root_is_Overworld = new_root is Overworld
	
	for c in additional_mains:
		c.set_visible(root_is_Overworld)

func _on_add_event_pressed():
	pass

func _on_action_sequence_pressed():
	pass
