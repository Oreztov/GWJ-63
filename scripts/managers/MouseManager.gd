extends Node2D

var grabbable = null

# Cursor images
@onready var cursor_default = preload("res://textures/cursors/cursor_new.png")
@onready var cursor_grab = preload("res://textures/cursors/cursor_grab.png")
@onready var cursor_pat = preload("res://textures/cursors/cursor_pat.png")

@onready var camera_reference = null

signal zoom_changed

func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_HIDDEN
	PowerManager.lost_power.connect(lose_power)
	PowerManager.regain_power.connect(regain_power)
	zoom_changed.connect(on_zoom_changed)

func _physics_process(delta):
	$CanvasLayer/Cursor.position = get_global_mouse_position()

# Called when the node enters the scene tree for the first time.
func _input(event):
	# Get mouse left click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			# If not holding anything
			if grabbable == null:
				# Detect if clicked on grabbable
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = get_global_mouse_position()
				var result = space_state.intersect_point(query)
				# Grab
				for collision in result:
					if collision.collider.is_in_group("grabbables"):
						collision.collider.grab()
			else:
				# Release grabbable
				grabbable.release()
		
func grab_cursor():
	$CanvasLayer/Cursor.play("grab")

func pat_cursor():
	$CanvasLayer/Cursor.play("pat")
	
func reset_cursor():
	if grabbable == null:
		$CanvasLayer/Cursor.play("default")
		
func on_zoom_changed():
	$CanvasLayer/Cursor.scale = Vector2(1/camera_reference.zoom_single, 1/camera_reference.zoom_single)
	
func lose_power():
	$CanvasLayer/Cursor/Flashlight.show()

func regain_power():
	$CanvasLayer/Cursor/Flashlight.hide()
