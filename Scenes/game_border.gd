class_name Border
extends Node2D
@onready var chunk = preload("res://Scenes/chunk.tscn")


@export var move_dir : Vector2 = Vector2.ZERO
@export var move_amount := 600.0
@export var corner : bool = false
var enabled: bool = false

func _ready():
	await get_tree().create_timer(0.05).timeout
	enabled = true

func spawn_chunk():
	var new_chunk = chunk.instantiate()
	get_parent().add_child(new_chunk)
	new_chunk.global_position = global_position

func spawn_new_border(dir:Vector2):
	var new_border = self.duplicate()
	get_parent().add_child(new_border)
	new_border.global_position = global_position + dir * move_amount
	new_border.move_dir = dir

func _on_visible_on_screen_notifier_2d_screen_entered():
	if enabled:
		spawn_chunk()
		if corner:
			spawn_new_border(Vector2(move_dir.x, 0.0))
			spawn_new_border(Vector2(move_dir.y, 0.0))
		global_position += move_dir * move_amount
