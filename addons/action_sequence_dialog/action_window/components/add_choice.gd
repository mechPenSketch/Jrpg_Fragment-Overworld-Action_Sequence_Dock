tool
extends Button

export(String, FILE, "*.tscn") var choice_filepath
var choice_file

func _ready():
	choice_file = load(choice_filepath)

func _on_connecting_editor_plugin(ep, _d):
	connect("pressed", ep, "_on_acbtn_pressed", [self, choice_file])
