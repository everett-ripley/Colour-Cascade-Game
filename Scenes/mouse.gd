extends Area2D
@onready var viewport = get_viewport()
@onready var collision_shape := $CollisionShape2D

func _process(delta):
	global_position = viewport.get_mouse_position()


func collision(enable:bool):
	collision_shape.disabled = !enable
