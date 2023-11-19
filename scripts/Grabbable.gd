extends CharacterBody2D

class_name Grabbable

@export var can_be_grabbed: bool = true
@export var item = false
@export var usage = 0.0

var grabbed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	add_to_group("grabbables")
	# No collision for a second
	if item:
		collision_layer = 2
		get_tree().create_timer(1, false, true).timeout.connect(enable_collision)
		
func enable_collision():
	collision_layer = 1
	
func _physics_process(delta):
	move_and_collide(Vector2.ZERO)
	if grabbed:
		global_position = get_global_mouse_position()
	
func grab():
	# Release any existing grabbed object
	if MouseManager.grabbable != null:
		MouseManager.grabbable.release()
	grabbed = true
	MouseManager.grabbable = self
	MouseManager.grab_cursor()
	
func release():
	grabbed = false
	MouseManager.grabbable = null
	MouseManager.reset_cursor()
	
func divide_usage(factor):
	if usage != 0:
		var new_usage = usage / factor
		PowerManager.change_usage(self, new_usage)
		
func reset_usage():
	PowerManager.change_usage(self, usage)
	
