extends Control

@onready var pages : Array = $HBoxContainer/Contents/Panel.get_children()

var index : int = 0

func _on_close_button_button_down():
	hide()


func _on_left_button_button_down():
	index -= 1
	update_page()


func _on_right_button_button_down():
	index += 1
	update_page()


func update_page():
	if index < 0:
		index = len(pages) - 1
	elif index >= len(pages):
		index = 0
	for i in range(len(pages)):
		if i == index:
			pages[i].show()
		else:
			pages[i].hide()
	print(index)
