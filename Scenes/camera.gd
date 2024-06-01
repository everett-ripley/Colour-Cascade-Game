extends Camera2D

@export var mouse : Area2D
@export var initial_speed : float = 50.0
@export var max_speed : float = 250.0
@export var acceleration : float = 15.0

var speed : float = initial_speed
var mouse_at_edge: bool = false



func _on_mouse_detector_area_entered(area):
	mouse_at_edge = false
	speed = initial_speed


func _on_mouse_detector_area_exited(area):
	mouse_at_edge = true

func _process(delta):
	if mouse_at_edge:
		var dir : Vector2 = to_local(mouse.global_position).normalized()
		global_position += dir * speed * delta
		if speed < max_speed:
			speed += acceleration * delta
			if speed > max_speed:
				speed = max_speed
		
