extends Area2D
@onready var viewport = get_viewport()

func _process(delta):
	global_position = viewport.get_mouse_position()
