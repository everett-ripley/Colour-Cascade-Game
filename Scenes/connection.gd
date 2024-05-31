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
	update_gradient(Vector3(1.0,1.0,1.0), 1)


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

func parent_updated(col:Vector3):
	update_gradient(col, 0)

func target_updated(col:Vector3):
	update_gradient(col, 2)

func _on_detector_area_entered(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = area.get_parent()
		var tween = create_tween()
		tween.tween_method(update_gradient.bind(2), Vector3(line.gradient.get_color(2).r, line.gradient.get_color(2).g, line.gradient.get_color(2).b), target_node.colour_values[target_node.colour], 0.3)
		#update_gradient(2, target_node.colour_values[target_node.colour])


func _on_detector_area_exited(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = null
		var tween = create_tween()
		tween.tween_method(update_gradient.bind(2), Vector3(line.gradient.get_color(2).r, line.gradient.get_color(2).g, line.gradient.get_color(2).b), Vector3(1.0,1.0,1.0), 0.3)
