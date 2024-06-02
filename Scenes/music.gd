extends Node
@onready var intro := $Intro
@onready var loop := $Loop

func _ready():
	loop.volume_db = linear_to_db(0.0)
	loop.play()
	loop.stop()
	intro.play()
	loop.volume_db = 0.0

func _on_intro_finished():
	loop.play()
