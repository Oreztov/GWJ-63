extends Node2D

var holding_cat = false
var cat_reference = null

# Cursor images
@onready var cursor_default = preload("res://textures/cursors/cursor_new.png")
@onready var cursor_grab = preload("res://textures/cursors/cursor_grab.png")


# Called when the node enters the scene tree for the first time.
func _input(event):
	# Get mouse left click
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_LEFT and event.pressed:
			if not holding_cat:
				# Detect if clicked on cat
				var space_state = get_world_2d().direct_space_state
				var query = PhysicsPointQueryParameters2D.new()
				query.position = get_viewport().get_mouse_position()
				var result = space_state.intersect_point(query)
				# Grab cat
				if len(result) > 0:
					if result[0].collider.is_in_group("cats"):
						cat_reference = result[0].collider
						holding_cat = true
						Input.set_custom_mouse_cursor(cursor_grab)
						cat_reference.is_grabbed = true
			else:
				# Release cat
				cat_reference.is_grabbed = false
				cat_reference = null
				holding_cat = false
				Input.set_custom_mouse_cursor(cursor_default)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if cat_reference != null:
		cat_reference.global_position = get_viewport().get_mouse_position()
