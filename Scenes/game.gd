extends Node

@onready var game_scene = preload("res://Scenes/game_scene.tscn")
@onready var main_menu := $Menus/MainMenu

func _on_start_button_button_down():
	main_menu.hide()
	var new_game = game_scene.instantiate()
	add_child(new_game)
