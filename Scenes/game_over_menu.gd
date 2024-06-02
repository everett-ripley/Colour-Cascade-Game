extends Control
@onready var network_size_label = $VBoxContainer/HBoxContainer/NetworkSizeLabel
@onready var colours_made_label = $VBoxContainer/HBoxContainer2/ColoursMadeLabel
@onready var total_score_label = $VBoxContainer/HBoxContainer3/TotalScoreLabel

@onready var game := $"../../.."

func game_over():
	get_tree().paused = true
	show()
	var tween = create_tween()
	tween.tween_property(self, "modulate", Color(1.0,1.0,1.0,1.0), 0.8)
	network_size_label.text = "[right][font_size=20]" + str(game.network_size)
	colours_made_label.text = "[right][font_size=20]" + str(game.colours_made)
	total_score_label.text = "[right][font_size=25]" + str(game.score)



func _on_menu_button_button_down():
	game.emit_signal("game_over", game.score)
