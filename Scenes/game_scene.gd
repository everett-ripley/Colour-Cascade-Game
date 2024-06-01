extends Node2D
@onready var camera := $Camera2D
@export var camera_limit : float = 500.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass#generate_new_chunks_from_position(Vector2(mouse.global_position.x/chunk_width, mouse.global_position.y/chunk_height))

func update_camera_limit(amount:float):
	camera_limit += amount
	camera.limit_bottom = camera_limit
	camera.limit_right = camera_limit
	camera.limit_left = -1 * camera_limit
	camera.limit_top = -1 * camera_limit

