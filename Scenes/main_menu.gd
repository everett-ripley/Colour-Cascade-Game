extends Control
@onready var reset_menu := $DataReset
@onready var tutorial := $TutorialMenu

func _on_close_button_button_down():
	reset_menu.hide()


func _on_data_button_button_down():
	reset_menu.show()


func _on_reset_button_button_down():
	reset_menu.hide()


func _on_tutorial_button_button_down():
	tutorial.show()
	tutorial.index = 0
	tutorial.update_page()
