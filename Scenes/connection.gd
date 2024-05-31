class_name Connection
extends Node2D

@onready var line := $Line2D
@onready var view_port := get_viewport()
@onready var detector := $Detector
var parent_node : ColourNode
var target_node : ColourNode = null
var mouse:Area2D

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

func interpolate_position(vec:Vector2):
	line.points[1] = vec


func _on_detector_area_entered(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = area.get_parent()
		


func _on_detector_area_exited(area):
	if area.is_in_group("ColourNodeArea"):
		target_node = null
		
