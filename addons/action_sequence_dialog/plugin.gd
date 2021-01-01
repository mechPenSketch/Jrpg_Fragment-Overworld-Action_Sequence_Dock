tool
extends EditorPlugin

var editor_selection
var editor_settings
var dock
var action_list

var main_font_size

func _enter_tree():
	var editor_interface = get_editor_interface()
	
	# DEFINE MAIN FONT SIZE
	var editor_settings = editor_interface.get_editor_settings()
	main_font_size = editor_settings.get_setting("interface/editor/main_font_size")
	editor_settings.connect("settings_changed", self, "_on_settings_changed")
	
	# SELECTIONS
	editor_selection = editor_interface.get_selection()
	editor_selection.connect("selection_changed", self, "_on_selection_changed")
	
	# ADD TO DOCK
	dock = load("res://addons/action_sequence_dialog/Dock.tscn").instance()
	add_control_to_dock(DOCK_SLOT_RIGHT_UR, dock)
	switch_dock_display(false)
	action_list = dock.find_node("List")
	resize_textedit()

func _exit_tree():
	# REMOVE FROM DOCK
	remove_control_from_docks(dock)
	dock.free()
	
	editor_selection.disconnect("selection_changed", self, "_on_selection_changed")
	editor_settings.disconnect("settings_changed", self, "_on_settings_changed")

func _on_selection_changed():
	for n in editor_selection.get_selected_nodes():
		if n is Event:
			switch_dock_display(true)
			return
	switch_dock_display(false)
	
func _on_settings_changed():
	main_font_size = editor_settings.get_setting("interface/editor/main_font_size")
	resize_textedit()

func get_standard_textedit_height():
	# TEXTEDIT'S MIN HEIGHT SHOULD BE 3 TIMES THE FONT SIZE
	#	1pt = 1.33px
	#	3pt = 4px
	return main_font_size * 4

func resize_textedit():
	for n in action_list.get_children():
		var t = n.find_node("TextEdit")
		if t:
			t.rect_min_size.y = get_standard_textedit_height()

func switch_dock_display(b:bool):
	dock.get_child(0).set_visible(!b)
	dock.get_child(1).set_visible(b)
