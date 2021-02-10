extends RichTextLabel

signal finish

var current_state
enum {HIDE, COMPLETE, PROGRESS}

var dvis = 1

func _action():
	match current_state:
		COMPLETE:
			emit_signal("finish")
			print("Fin")

func _on_dialog_visibility_changed():
	if get_parent().is_visible():
		change_state(PROGRESS)
	else:
		change_state(HIDE)

func _process(delta):
	visible_characters += dvis
	
	if visible_characters >= get_total_character_count():
		print("C")
		change_state(COMPLETE)

func _ready():
	set_process(false)

func activate_state():
	match current_state:
		PROGRESS:
			set_process(true)

func change_state(i):
	deactivate_state()
	current_state = i
	activate_state()

func deactivate_state():
	match current_state:
		PROGRESS:
			set_process(false)
