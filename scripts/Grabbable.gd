extends CharacterBody2D

class_name Grabbable

@export var can_be_grabbed: bool = true

var grabbed = false


# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("grabbables")
	
func _physics_process(delta):
	if grabbed:
		global_position = get_viewport().get_mouse_position()
	
func grab():
	# Release any existing grabbed object
	if MouseManager.grabbable != null:
		MouseManager.grabbable.release()
	grabbed = true
	MouseManager.grabbable = self
	
func release():
	grabbed = false
	MouseManager.grabbable = null
	
