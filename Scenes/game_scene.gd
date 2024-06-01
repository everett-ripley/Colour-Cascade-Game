extends Node2D
@onready var chunk = preload("res://Scenes/chunk.tscn")
@onready var camera := $Camera2D
@onready var mouse := $Mouse
@export var chunk_unit_size : float = 60.0
@export var chunk_x_units : int = 10
@export var chunk_y_units : int = 10
@export var initial_size : int = 3 #describes both rows and columns
@export var camera_limit : float = 500.0

const generate_distance : int = 2
var generated_chunks = {}
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
	generate_new_chunks_from_position(mouse.global_position/chunk_unit_size)

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
			register_chunk(x,y)
	print(generated_chunks)


func check_for_chunk(x,y):
	if x in generated_chunks and y in generated_chunks[x] and generated_chunks[x][y] == true:
		return true
	else:
		return false

func register_chunk(x,y):
	if x in generated_chunks:
		generated_chunks[x][y] = true
	else:
		generated_chunks[x] = {y : true}

func generate_new_chunk(x,y):
	if !check_for_chunk(x,y):
		add_chunk(Vector2(x*chunk_unit_size,y*chunk_unit_size))
		register_chunk(x,y)
	pass

func generate_new_chunks_from_position(pos:Vector2):
	for x in range(generate_distance*2):
		x += pos.x - generate_distance
		for y in range(generate_distance*2):
			y += pos.y - generate_distance
			generate_new_chunk(x,y)


func add_chunk(pos:Vector2):
	var new_chunk = chunk.instantiate()
	new_chunk.position = pos
	add_child(new_chunk)
