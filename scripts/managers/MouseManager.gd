extends Node2D

var grabbable = null

# Cursor images
@onready var cursor_default = preload("res://textures/cursors/cursor_new.png")
@onready var cursor_grab = preload("res://textures/cursors/cursor_grab.png")
@onready var cursor_pat = preload("res://textures/cursors/cursor_pat.png")


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
				query.position = get_viewport().get_mouse_position()
				var result = space_state.intersect_point(query)
				# Grab
				for collision in result:
					if collision.collider.is_in_group("grabbables"):
						collision.collider.grab()
			else:
				# Release grabbable
				grabbable.release()
		
func pat():
	# If not holding anything
	if grabbable == null:
		# Pat
		Input.set_custom_mouse_cursor(cursor_pat)
		get_tree().create_timer(0.25, true, true).timeout.connect(reset_cursor)
		
func reset_cursor():
	# If not holding anything
	if grabbable == null:
		# Default cursor
		Input.set_custom_mouse_cursor(cursor_default)
