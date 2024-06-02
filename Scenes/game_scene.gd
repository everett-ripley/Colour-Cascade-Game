extends Node2D
@onready var camera := $Camera2D
@onready var health_bar := $HudCanvas/HUD/VBoxContainer/HealthBar
@onready var score_label := $HudCanvas/HUD/VBoxContainer/HBoxContainer/ScoreLabel
@onready var game_over_screen := $HudCanvas/HUD/GameOverScreen
@onready var network_size_label = $HudCanvas/HUD/GameOverScreen/VBoxContainer/HBoxContainer/NetworkSizeLabel
@onready var colours_made_label = $HudCanvas/HUD/GameOverScreen/VBoxContainer/HBoxContainer2/ColoursMadeLabel
@onready var total_score_label = $HudCanvas/HUD/GameOverScreen/VBoxContainer/HBoxContainer3/TotalScoreLabel
@export var camera_limit : float = 500.0
@export var health : float = 1000.0
@export var connection_unit_cost : float = 0.2

signal game_over(final_score:int)

var network_size:=1
var colours_made:=0
var dead_nodes:=0

var score := 0
# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	
	if Input.is_action_just_pressed("Reset"):
		camera.global_position = Vector2.ZERO

func update_camera_limit(amount:float):
	camera_limit += amount
	camera.limit_bottom = camera_limit
	camera.limit_right = camera_limit
	camera.limit_left = -1 * camera_limit
	camera.limit_top = -1 * camera_limit

func node_activated():
	health = clamp(health, 0.0, 1000.0)
	score += 50
	update_score(score)
	network_size += 1
	#tween_score(50)
	#update_health_bar() - uncomment if health impact is changed

func node_flipped(difference:int):
	health = clamp(health + 7.5 * difference, 0.0, 1000.0)
	score += 20 * difference
	update_score(score)
	#tween_score(20 * difference)
	update_health_bar()
	colours_made += 1

func node_killed():
	health = clamp(health - 50, 0.0, 1000.0)
	update_health_bar()
	dead_nodes+=1
	if dead_nodes == network_size:
		end_game()

func connection_made(length:float):
	health = clamp(health - length * connection_unit_cost, 0.0, 1000.0)
	update_health_bar()

func update_health_bar():
	var tween = create_tween()
	tween.tween_property(health_bar, "value", 1000 - health, 0.1)
	if health <= 0:
		end_game()

func end_game():
	game_over_screen.game_over()
	#get_tree().paused = true
	#game_over_screen.show()
	#var tween = create_tween()
	#tween.tween_property(game_over_screen, "modulate", Color(1.0,1.0,1.0,1.0), 0.8)
	#network_size_label.text = "[right][font_size=20]" + str(network_size)
	#colours_made_label.text = "[right][font_size=20]" + str(colours_made)
	#total_score_label.text = "[right][font_size=25]" + str(score)

func tween_score(amount:int):
	#var old := int(score_label.text)
	var tween = create_tween()
	tween.tween_method(update_score, 0, amount, 0.3)

func update_score(s:int):
	var score_string = str(s)
	if len(score_string) < len("0000000"):
		var amount : int = len("0000000") - len(score_string)
		for i in range(amount):
			score_string = "0" + score_string
	score_label.text = "[center][font_size=25]" + score_string


