extends Node2D
@onready var chunk = preload("res://Scenes/chunk.tscn")
@onready var camera := $Camera2D
@export var chunk_unit_size : float = 60.0
@export var chunk_x_units : int = 10
@export var chunk_y_units : int = 10
@export var initial_size : int = 3 #describes both rows and columns
@export var camera_limit : float = 500.0

var chunk_height : float
var chunk_width : float

# Called when the node enters the scene tree for the first time.
func _ready():
	#update_camera_limit(0)
	chunk_height = chunk_unit_size * chunk_y_units
	chunk_width = chunk_unit_size * chunk_x_units
	
	generate_map()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_camera_limit(amount:float):
	camera_limit += amount
	camera.limit_bottom = camera_limit
	camera.limit_right = camera_limit
	camera.limit_left = -1 * camera_limit
	camera.limit_top = -1 * camera_limit


func generate_map():
	var offset :Vector2 = -1 * Vector2(chunk_width, chunk_height)
	for y in initial_size:
		for x in initial_size:
			var pos : Vector2 = Vector2(x * chunk_width,y * chunk_height) + offset
			add_chunk(pos)
	

func expand_edges():
	pass


func add_chunk(pos:Vector2):
	var new_chunk = chunk.instantiate()
	new_chunk.position = pos
	add_child(new_chunk)
