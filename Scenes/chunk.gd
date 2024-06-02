class_name Chunk
extends Node2D

@export var unit_size : float = 50.0
@export var x_units : int = 20
@export var y_units : int = 20
@export var frequency : float = 1.5
@export var shift_randomness : float = 15.0
@export var minimum_nodes : int = 8
@onready var colour_node_scene := preload("res://Scenes/colour_node.tscn")

var colour_nodes : Array[ColourNode]
var rng = RandomNumberGenerator.new()
var noise = FastNoiseLite.new()


func _ready():
	await get_tree().create_timer(0.05).timeout
	rng.randomize()
	noise.seed = randi()
	noise.fractal_octaves = 8
	noise.fractal_lacunarity = 10
	generate_nodes()

func generate_nodes()->void:
	var parent = get_parent()
	var offset : Vector2 = -1 * Vector2(x_units*unit_size, y_units*unit_size) / 2
	for y in (y_units):
		for x in (x_units):
			var rand = round(abs(noise.get_noise_2d(x*unit_size,y*unit_size))*frequency)
			#print(rand)
			if rand > 0.2:
				var new_node = colour_node_scene.instantiate()
				add_child(new_node)
				var randomness : Vector2 = Vector2(randf_range(-1*shift_randomness, shift_randomness),randf_range(-1*shift_randomness, shift_randomness))
				new_node.position = Vector2(x,y) * unit_size + randomness + offset
				colour_nodes.append(new_node)
				new_node.connect("activated", parent.node_activated)
				new_node.connect("dead", parent.node_killed)
				new_node.connect("colour_flipped", parent.node_flipped)
				new_node.game_root = parent
	
	if len(colour_nodes) < minimum_nodes:
		for i in colour_nodes:
			i.queue_free()
		colour_nodes = []
		rng.randomize()
		noise.seed = randi()
		generate_nodes()
		
	
	if global_position == Vector2.ZERO:
		for node in colour_nodes:
			var pos: Vector2 = node.global_position
			if -5 < pos.x and pos.x < 15:
				if -5 < pos.y and pos.x < 15:
					var index : int = colour_nodes.find(node)
					colour_nodes.remove_at(index)
					node.queue_free()
					
	print(len(colour_nodes))
