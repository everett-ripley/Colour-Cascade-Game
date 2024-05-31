class_name ColourNode
extends Node2D

@onready var connection_scene := preload("res://Scenes/connection.tscn")
@onready var mat = preload("res://Shaders/colour_node_material.tres")
@onready var sprite := $Sprite2D
@export var starting_node : bool = false

@export_enum("red",
 "red_orange",
 "orange",
 "yellow_orange",
 "yellow",
 "yellow_green",
 "green",
"blue_green",
"blue",
"blue_violet",
"violet",
"red_violet") var colour = 0

var colour_values : Array[Vector3] = [
	Vector3(1.0,0.0,0.0), #red
	Vector3(1.0, 0.3, 0.0), #red_orange
	Vector3(1.0, 0.5, 0.0), #orange
	Vector3(1.0, 0.8, 0.0), #yellow_orange
	Vector3(1.0,1.0,0.0), #yellow
	Vector3(0.75,1.0,0.0), #yellow_green
	Vector3(0.0,1.0,0.0), #green
	Vector3(0.0,0.5,0.5), #blue_green
	Vector3(0.0,0.0,1.0), #blue
	Vector3(0.33,0.0,1.0), #blue_violet
	Vector3(0.6,0.0,0.6), #violet
	Vector3(0.8, 0.0, 0.4) #red_violet
]

enum states {
	inert,
	active,
	dead
}
var state = states.inert

var connections : Array[ColourNode]

var mouse_in_node : bool = false

var mouse:Area2D

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material = mat.duplicate()
	if starting_node:
		change_state(states.active)
	update_colour()
	

func receive_update(received_colour:int, source:ColourNode):
	if source.state == states.dead:
		change_state(states.dead)
	elif state != states.dead:
		mix_colours(received_colour, source)
	await get_tree().create_timer(1.0, false).timeout
	for node in connections:
		if node != source:
			node.receive_update(colour, self)

func mix_colours(received_colour:int, source:ColourNode):
	var difference : int = abs(received_colour - colour)
	var shift_direction:int
	if difference == 6:#Holy shit, this is bad.
		change_state(states.dead)
		return
	elif difference == 1:
		colour = received_colour
	elif difference < 6:
		shift_direction = (colour + received_colour)/2
		colour = shift_direction
		
	elif difference > 6:
		shift_direction = (colour + received_colour)/2
		colour = (shift_direction + 6)
		
	if colour < 0:
		colour += 11
	elif colour > 11:
		colour -= 11
	update_colour()
	

func update_colour():
	sprite.material.set("shader_parameter/colour", colour_values[colour])

func change_state(new:int):
	match new:
		states.inert:
			pass
		states.active:
			pass
		states.dead:
			sprite.material.set("shader_parameter/colour", Vector3(1.0,1.0,1.0))
	state = new


func _process(delta):
	match state:
		states.inert:
			pass
		states.active:
			if Input.is_action_just_pressed("LMB") and mouse_in_node:
				var connection : Connection = connection_scene.instantiate()
				add_child(connection)
				connection.global_position = global_position
				connection.parent_node = self
				if mouse != null:
					mouse.collision(false)
					connection.mouse = mouse
		states.dead:
			pass


func _on_mouse_collider_area_entered(area):
	if area.is_in_group("Mouse"):
		mouse = area
		match state:
			states.inert:
				pass
			states.active:
				mouse_in_node = true
			states.dead:
				return


func _on_mouse_collider_area_exited(area):
	if area.is_in_group("Mouse"):
		match state:
			states.inert:
				pass
			states.active:
				mouse_in_node = false
			states.dead:
				return
