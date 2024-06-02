extends Node
@onready var intro := $Intro
@onready var loop := $Loop

func _ready():
	intro.play()

func _on_intro_finished():
	loop.play()
