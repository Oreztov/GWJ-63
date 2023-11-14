extends Camera2D

@export var camera_speed = 25
@export var zoom_speed = 0.1

@export var zoom_min = 1.75
@export var zoom_max = 0.33
var zoom_single = zoom.x

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MouseManager.camera_reference = self
	SpawnManager.main_reference = get_parent()

func _input(event):
	# Check for scrolling up or down
	if event is InputEventMouseButton:
		# Zoom in
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_single += zoom_speed
			position = get_global_mouse_position()
		# Zoom out
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_single -= zoom_speed
		zoom_single = clamp(zoom_single, zoom_max, zoom_min)
		zoom = Vector2(zoom_single, zoom_single)
		MouseManager.zoom_changed.emit()
		# Check for camera dragging
		if event.is_pressed():
			dragging = true
			MouseManager.grab_cursor()
		else:
			dragging = false
			MouseManager.reset_cursor()
	elif event is InputEventMouseMotion and dragging:
		position += -event.relative
