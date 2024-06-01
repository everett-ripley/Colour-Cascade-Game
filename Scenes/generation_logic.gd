extends Node
@onready var chunk = preload("res://Scenes/chunk.tscn")
@onready var mouse := $"../Mouse"
@onready var game_root := $".."
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
	generate_new_chunks_from_position(Vector2(mouse.global_position.x/chunk_width, mouse.global_position.y/chunk_height))


func generate_map():
	var offset :Vector2 = -1 * Vector2(chunk_width, chunk_height)
	for y in initial_size:
		for x in initial_size:
			var pos : Vector2 = Vector2(x * chunk_width,y * chunk_height) + offset
			add_chunk(pos)
			register_chunk(x-1,y-1)
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
	print(generated_chunks)

func generate_new_chunk(x,y):
	if !check_for_chunk(x,y):
		add_chunk(Vector2(x*chunk_width,y*chunk_height))
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
	game_root.call_deferred("add_child", new_chunk)
