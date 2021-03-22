tool
extends Button

func _on_connecting_editor_plugin(ep, _d):
	connect("pressed", ep, "_on_acbtn_pressed", [self])
