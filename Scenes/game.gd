extends Node

@onready var game_scene = preload("res://Scenes/game_scene.tscn")
@onready var main_menu := $Menus/MainMenu
@onready var options_menu := $Menus/OptionsMenu
@onready var data := $Data
@onready var high_score_label := $Menus/MainMenu/VBoxContainer/HBoxContainer3/HighScoreLabel
var active_game : Node2D = null
var can_pause : bool = false

func _ready():
	get_tree().paused = true
	data.recover_data()
	update_high_score(data.high_score)


func _on_start_button_button_down():
	main_menu.hide()
	var new_game = game_scene.instantiate()
	add_child(new_game)
	new_game.connect("game_over", game_over)
	new_game.connect("show_options", _on_options_button_down)
	active_game = new_game
	get_tree().paused = false
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN



func game_over(score):
	main_menu.show()
	active_game.queue_free()
	active_game = null
	if score > data.high_score:
		data.high_score = score
		data.save_game()
		update_high_score(score)

func update_high_score(score:int):
	var s :String = str(score)
	var diff :int = len("0000000") - len(s)
	if diff > 0:
		for i in range(diff):
			s = "0" + s
	high_score_label.text = "[center][font_size=30]" + s

func _on_options_button_down():
	options_menu.show()


func _on_reset_button_button_down():
	data.reset_data()
	update_high_score(data.high_score)
