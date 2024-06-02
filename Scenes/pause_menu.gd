extends Control

@onready var root := $"../.."


func _process(delta):
	if Input.is_action_just_pressed("pause"):
		change_paused()

func change_paused():
	get_tree().paused = !get_tree().paused
	if get_tree().paused:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		show()
	else:
		Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
		hide()

func _on_resume_button_button_down():
	change_paused()


func _on_quit_button_button_down():
	root.end_game()
	hide()
