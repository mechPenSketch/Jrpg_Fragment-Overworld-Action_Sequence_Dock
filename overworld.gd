extends Node

class_name Overworld

var state = 0
enum {NORM, DIALOG}

var current_event
var current_event_as
var action_index

export(NodePath) var np_dialog
var dialog
var dialog_text

func _ready():
	dialog = get_node(np_dialog)
	dialog_text = dialog.find_node("Text")
	
func _onto_next_action():
	if action_index < current_event_as.size() - 1:
		action_index += 1
		perform_action()
	else:
		end_action()

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

func end_action():
	change_state(NORM)

func initiate_action_sequence(e, i):
	current_event = e
	current_event_as = e.action_sequences
	action_index = i
	
	perform_action()

func leave_pause_to_state():
	get_tree().paused = state in [DIALOG]

func perform_action():
	# GET ACTION: DICTIONARY
	var ad = current_event_as[action_index]
	match ad["action_type"]:
		"Text":
			set_dialog(ad["default_text"])
		_:
			# END
			end_action()

func set_dialog(txt):
	dialog_text.set_text(txt)
	change_state(DIALOG)
