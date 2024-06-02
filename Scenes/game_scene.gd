extends Node2D
@onready var camera := $Camera2D
@export var camera_limit : float = 500.0
@export var health : float = 1000.0
@export var connection_unit_cost : float = 0.1

# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	$Label.text = str(health)
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
	

func node_flipped(difference:int):
	health = clamp(health + 15 * difference, 0.0, 1000.0)
	

func node_killed():
	health = clamp(health - 25, 0.0, 1000.0)
	

func connection_made(length:float):
	health = clamp(health - length * connection_unit_cost, 0.0, 1000.0)
