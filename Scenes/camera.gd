extends Camera2D

@export var mouse : Area2D
@export var initial_speed : float = 50.0
@export var max_speed : float = 250.0
@export var acceleration : float = 15.0
@export var zoom_rate : float = 0.25
@export var max_zoom : float = 2.0
@export var min_zoom : float = 0.5
@onready var collision_shape := $MouseDetector/CollisionShape2D

var speed : float = initial_speed
var mouse_at_edge: bool = false
var initial_height : float
var initial_radius : float


func _ready():
	collision_shape.shape.height = 940
	collision_shape.shape.radius = 222
	initial_height = collision_shape.shape.height
	initial_radius = collision_shape.shape.radius


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
	
	zoom_camera(delta)

func zoom_camera(delta:float):
	var zoom_dir : int = 0
	if Input.is_action_just_released("ZoomIn"):
		zoom_dir = 1
	elif Input.is_action_just_released("ZoomOut"):
		zoom_dir = -1
	else:
		return
	zoom.x += zoom_rate * zoom_dir * delta * 10
	zoom.x = clamp(zoom.x, min_zoom, max_zoom)
	zoom.y = zoom.x
	collision_shape.shape.height = initial_height * (1/zoom.x)
	collision_shape.shape.radius = initial_radius * (1/zoom.x)
