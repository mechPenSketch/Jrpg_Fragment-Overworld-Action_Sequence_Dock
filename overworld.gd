extends Node

class_name Overworld

var state = 0
enum {NORM, DIALOG}

export(NodePath) var np_dialog
var dialog
var dialog_text

func _ready():
	dialog = get_node(np_dialog)
	dialog_text = dialog.get_node("Text")

func activate_state():
	leave_pause_to_state()
	
	match state:
		DIALOG:
			dialog.show()

func change_state(new_state):
	if state != new_state:
		deactivate_state()
		state = new_state
		activate_state()

func deactivate_state():
	match state:
		DIALOG:
			dialog.hide()

func leave_pause_to_state():
	get_tree().paused = state in [DIALOG]

func set_dialog(txt):
	dialog_text.set_text(txt)
	change_state(DIALOG)
