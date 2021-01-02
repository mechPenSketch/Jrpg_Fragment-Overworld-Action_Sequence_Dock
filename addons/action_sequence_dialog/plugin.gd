tool
extends EditorPlugin

var editor_selection
var editor_settings
var dock
var action_list

var as_property
const ERR_MISSING_PROPERTY = 3
const ERR_WRONG_HINT = 2

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
		if n.has_meta("as_property"):
			var str_property = n.get_meta("as_property")
			var dic_property
			for p in n.get_property_list():
				if p.name == str_property:
					dic_property = p
					break
			
			# TARGETTED PROPERTY SHOULD HAVE:
			#	THE USAGE THAT, IN ADDITION TO DEFAULT SETTINGS,
			#		SOULD BE STORABLE (usage: 8199)
			#	THE EXPORT HINT OF ARRAY (hint: 24) FOLLOWED BY
			#		DICTIONARY (hint_string: "18:")
			if dic_property:
				if dic_property['usage'] == 8199 and dic_property['hint'] == 24 and dic_property['hint_string'] == "18:":
					as_property = get(n.get_meta("as_property"))
					switch_dock_display(true)
				else:
					switch_dock_display(ERR_WRONG_HINT)
				return
			else:
				switch_dock_display(ERR_MISSING_PROPERTY)
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

func switch_dock_display(v):
	var i
	if v is int:
		i = v
	else:
		i = int(v)
	
	for j in dock.get_child_count():
		dock.get_child(j).set_visible(j == i)
