class_name Connection
extends Node2D

@onready var line := $Line2D
@onready var view_port := get_viewport()
@onready var detector := $Detector
@onready var gradient = preload("res://Materials/connection_gradient.tres")
var parent_node : ColourNode
var target_node : ColourNode = null
var mouse:Area2D


func _ready():
	line.gradient = gradient.duplicate()
	update_gradient(Vector3(1.0,1.0,1.0), 1)
	update_gradient(Vector3(1.0,1.0,1.0), 2)
	update_gradient(Vector3(1.0,1.0,1.0), 3)


func _process(delta):
	line.points[1] = to_local(view_port.get_mouse_position())
	detector.position = line.points[1]
	if Input.is_action_just_pressed("LMB") and target_node != null and target_node != parent_node and target_node.state != target_node.states.active:
		make_connection()
		if mouse != null:
			mouse.collision(true)
	if Input.is_action_just_pressed("RMB"):
		if mouse != null:
			mouse.collision(true)
		queue_free()

func make_connection():
	set_process(false)
	var tween = create_tween()
	#tween.tween_property(line, "points/indices/1", to_local(target_node.global_position), 0.3)
	tween.tween_method(interpolate_position, line.points[1], to_local(target_node.global_position), 0.3)
	target_node.connections.append(parent_node)
	parent_node.connections.append(target_node)
	parent_node.receive_update(target_node.colour, target_node)
	target_node.change_state(target_node.states.active)
	target_node.connect("colour_updated", target_updated)

func interpolate_position(vec:Vector2):
	line.points[1] = vec


func update_gradient(color:Vector3, point:int):
	line.gradient.set_color(point, Color(color[0],color[1],color[2]))

#unideal solution, since it's almost identical logic to the colour_node. Ideally this would be moved to some kind of library
func mix_nodes(parent_colour:int, target_colour:int)->Vector3:
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
	var difference = abs(target_colour - parent_colour)
	if difference == 6 or difference == 0:
		return Vector3(1.0,1.0,1.0)
	var return_colour : int
	if difference == 1:
		return_colour = target_colour
	elif difference < 6:
		return_colour = (parent_colour + target_colour)/2
	elif difference > 6:
		return_colour = (parent_colour + target_colour)/2 + 6
	if return_colour < 0:
		return_colour += 11
	elif return_colour > 11:
		return_colour -= 11
	return colour_values[return_colour]


func parent_updated(col:Vector3):
	update_gradient(col, 0)
	#update_gradient(mix_nodes(parent_node.colour, target_node.colour), 1)
	#update_gradient(mix_nodes(parent_node.colour, target_node.colour), 2)

func target_updated(col:Vector3):
	update_gradient(col, 3)
	#update_gradient(mix_nodes(parent_node.colour, target_node.colour), 1)
	#update_gradient(mix_nodes(parent_node.colour, target_node.colour), 2)

func _on_detector_area_entered(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = area.get_parent()
		var tween = create_tween()
		tween.tween_method(update_gradient.bind(3), Vector3(line.gradient.get_color(3).r, line.gradient.get_color(3).g, line.gradient.get_color(3).b), target_node.colour_values[target_node.colour], 0.3)
		#tween.parallel().tween_method(update_gradient.bind(1), Vector3(line.gradient.get_color(1).r, line.gradient.get_color(1).g, line.gradient.get_color(1).b), mix_nodes(parent_node.colour, target_node.colour), 0.3)
		#tween.parallel().tween_method(update_gradient.bind(2), Vector3(line.gradient.get_color(2).r, line.gradient.get_color(2).g, line.gradient.get_color(2).b), mix_nodes(parent_node.colour, target_node.colour), 0.3)
		tween.parallel().tween_method(update_gradient.bind(0), Vector3(line.gradient.get_color(0).r, line.gradient.get_color(0).g, line.gradient.get_color(0).b), mix_nodes(parent_node.colour, target_node.colour), 0.3)


func _on_detector_area_exited(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = null
		var tween = create_tween()
		tween.tween_method(update_gradient.bind(3), Vector3(line.gradient.get_color(3).r, line.gradient.get_color(3).g, line.gradient.get_color(3).b), Vector3(1.0,1.0,1.0), 0.3)
		#tween.parallel().tween_method(update_gradient.bind(1), Vector3(line.gradient.get_color(1).r, line.gradient.get_color(1).g, line.gradient.get_color(1).b), Vector3(1.0,1.0,1.0), 0.3)
		#tween.parallel().tween_method(update_gradient.bind(2), Vector3(line.gradient.get_color(2).r, line.gradient.get_color(2).g, line.gradient.get_color(2).b), Vector3(1.0,1.0,1.0), 0.3)
		tween.parallel().tween_method(update_gradient.bind(0), Vector3(line.gradient.get_color(0).r, line.gradient.get_color(0).g, line.gradient.get_color(0).b), parent_node.colour_values[parent_node.colour], 0.3)
