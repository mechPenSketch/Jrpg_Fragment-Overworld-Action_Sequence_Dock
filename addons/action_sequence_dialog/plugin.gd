tool
extends EditorPlugin

var additional_mains

func _enter_tree():
	connect("scene_changed", self, "_on_scene_changed")
	
	# ADD TO MAIN TOOLBAR
	var scn_at = load("AdditionalToolbar.tscn")
	additional_mains = scn_at.get_children()
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
