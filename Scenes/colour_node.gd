class_name ColourNode
extends Node2D

@onready var mat = preload("res://Shaders/colour_node_material.tres")
@onready var sprite := $Sprite2D

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

# Called when the node enters the scene tree for the first time.
func _ready():
	sprite.material = mat.duplicate()
	update_colour()
	await get_tree().create_timer(1.0).timeout
	mix_colours(4, self)
	print(colour)
	await get_tree().create_timer(1.0).timeout
	mix_colours(7, self)
	print(colour)
	await get_tree().create_timer(1.0).timeout
	mix_colours(0, self)
	print(colour)
	await get_tree().create_timer(1.0).timeout
	mix_colours(11, self)
	print(colour)


func mix_colours(received_colour:int, source:ColourNode):
	var difference : int = abs(received_colour - colour)
	if difference == 6:
		change_state(states.dead)
		return
	elif difference == 1:
		colour = received_colour
		update_colour()
	else:
		#shift to new colour value
		var shift_direction:int = round((difference+0.01)/2) * (difference/(received_colour - colour))# * (2 * int(difference<6) - 1)
		
		colour += shift_direction
		print("true colour", colour)
		if colour < 0:
			colour += 11
		elif colour > 11:
			colour -= 11
		update_colour()
	
	#this part of the function is where the colour node signals the change to other connected nodes

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

func _on_mouse_collider_mouse_entered():
	match state:
		states.inert:
			pass
		states.active:
			pass
		states.dead:
			return


func _on_mouse_collider_mouse_exited():
	match state:
		states.inert:
			pass
		states.active:
			pass
		states.dead:
			return
