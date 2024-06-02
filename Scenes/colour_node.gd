class_name ColourNode
extends Node2D

@onready var connection_scene := preload("res://Scenes/connection.tscn")
@onready var mat = preload("res://Shaders/colour_node_material.tres")
@onready var aura_mat = preload("res://Shaders/aura_shader.tres")
@onready var sprite := $Sprite2D
@onready var aura := $AuraSprite
@onready var shockwave := $ShockWave
@onready var flipped_audio := $Flipped
@onready var hover_audio := $Hover
@onready var dead_audio := $Dead
@export var starting_node : bool = false
@export var game_root:Node2D
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

signal colour_updated(new_col:Vector3)

signal colour_flipped(difference:int)

signal activated

signal dead

# Called when the node enters the scene tree for the first time.
func _ready():
	colour = randi_range(0, 11)
	sprite.material = mat.duplicate()
	aura.material = aura_mat.duplicate()
	shockwave.material = shockwave.material.duplicate()
	if starting_node:
		change_state(states.active)
	update_colour(false)
	update_shockwave(Vector3.ZERO)
	flipped_audio.pitch_scale = randf_range(0.85,1.15)
	hover_audio.pitch_scale = randf_range(0.85,1.15)
	dead_audio.pitch_scale = randf_range(0.85,1.15)

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
	if difference == 6 or difference == 0:#Holy shit, this is bad.
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
	emit_signal("colour_flipped", difference)
	update_colour()
	

func update_colour(emit_shockwave:bool=true):
	sprite.material.set("shader_parameter/colour", colour_values[colour])
	aura.material.set("shader_parameter/colour", colour_values[colour])
	shockwave.material.set("shader_parameter/colour", colour_values[colour])
	emit_signal("colour_updated", colour_values[colour])
	if emit_shockwave:
		flipped_audio.play()
		var tween = create_tween()
		tween.tween_method(update_shockwave, Vector3(0.5, 0.0, 0.4), Vector3(0.0, 0.425, 0.0), 0.9)


func update_shockwave(force_size_alpha:Vector3):
	shockwave.material.set("shader_parameter/force", force_size_alpha[0])
	shockwave.material.set("shader_parameter/size", force_size_alpha[1])
	shockwave.material.set("shader_parameter/alpha", force_size_alpha[2])
	


func change_state(new:int):
	match new:
		states.inert:
			pass
		states.active:
			aura.show()
			emit_signal("activated")
		states.dead:
			aura.hide()
			sprite.material.set("shader_parameter/colour", Vector3(1.0,1.0,1.0))
			emit_signal("colour_updated", Vector3(1.0,1.0,1.0))
			if state != states.dead:
				await get_tree().create_timer(0.05).timeout
				emit_signal("dead")
				dead_audio.play()
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
				connection.update_gradient(colour_values[colour], 0)
				connect("colour_updated", connection.parent_updated)
				connection.game_root = game_root
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
				hover_audio.play()
				var tween = create_tween()
				tween.tween_property(sprite, "scale", Vector2(0.06,0.06), 0.1)
			states.dead:
				return


func _on_mouse_collider_area_exited(area):
	if area.is_in_group("Mouse"):
		match state:
			states.inert:
				pass
			states.active:
				mouse_in_node = false
				var tween = create_tween()
				tween.tween_property(sprite, "scale", Vector2(0.05,0.05), 0.1)
			states.dead:
				return


func _on_visible_on_screen_notifier_2d_screen_entered():
	sprite.show()


func _on_visible_on_screen_notifier_2d_screen_exited():
	sprite.hide()
