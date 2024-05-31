extends Node2D

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
"violet") var colour = 0

var colour_values : Array[Vector3] = [
	
]

enum states {
	inert,
	active,
	dead
}
var state = states.inert

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


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
