extends Area2D
@onready var viewport = get_viewport()
@onready var collision_shape := $CollisionShape2D

@export var camera : Camera2D

var window_size : Vector2

func _ready():
	window_size = viewport.get_visible_rect().size
	

func _process(delta):
	global_position = viewport.get_mouse_position() + (camera.global_position - window_size/2)


func collision(enable:bool):
	collision_shape.disabled = !enable
