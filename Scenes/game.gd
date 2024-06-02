extends Node

@onready var game_scene = preload("res://Scenes/game_scene.tscn")
@onready var main_menu := $Menus/MainMenu
var active_game : Node2D = null
var can_pause : bool = false

func _ready():
	get_tree().paused = true
	


func _on_start_button_button_down():
	main_menu.hide()
	var new_game = game_scene.instantiate()
	add_child(new_game)
	new_game.connect("game_over", game_over)
	active_game = new_game
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func game_over(score):
	main_menu.show()
	active_game.queue_free()
	active_game = null
	
