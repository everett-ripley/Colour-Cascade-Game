extends Control
@onready var reset_menu := $DataReset

func _on_close_button_button_down():
	reset_menu.hide()


func _on_data_button_button_down():
	reset_menu.show()


func _on_reset_button_button_down():
	reset_menu.hide()
