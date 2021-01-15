tool
extends LineEdit

export(String) var associated_key

func _on_connecting_editor_plugin(ep, d):
	if d.has(associated_key):
		text = d[associated_key]
	
	connect("text_changed", ep, "_on_le_changed", [self])
