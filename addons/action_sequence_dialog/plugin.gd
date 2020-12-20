tool
extends EditorPlugin


func _enter_tree():
	connect("scene_changed", self, "_on_scene_changed")
	
	# ADD TOOLBARS
	#add_control_to_container(CONTAINER_CANVAS_EDITOR_MENU, control)

func _exit_tree():
	hide_plugin_toolbars()
	
	disconnect("scene_changed", self, "_on_scene_changed")

func _on_scene_changed(new_root):
	hide_plugin_toolbars()
	
	if new_root is Overworld:
		print("Add toolbar")

func hide_plugin_toolbars():
	pass
