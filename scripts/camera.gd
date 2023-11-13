extends Camera2D

@export var camera_speed = 25
@export var zoom_speed = 0.1

@export var zoom_min = 2
@export var zoom_max = 0.4
var zoom_single = zoom.x

var dragging = false

# Called when the node enters the scene tree for the first time.
func _ready():
	MouseManager.camera_reference = self
	SpawnManager.main_reference = get_parent()

func _input(event):
	# Check for scrolling up or down
	if event is InputEventMouseButton:
		if event.button_index == MOUSE_BUTTON_WHEEL_UP:
			zoom_single += zoom_speed
		elif event.button_index == MOUSE_BUTTON_WHEEL_DOWN:
			zoom_single -= zoom_speed
		zoom_single = clamp(zoom_single, zoom_max, zoom_min)
		zoom = Vector2(zoom_single, zoom_single)
		# Check for camera dragging
		if event.is_pressed():
			dragging = true
			MouseManager.grab_cursor()
		else:
			dragging = false
			MouseManager.reset_cursor()
	elif event is InputEventMouseMotion and dragging:
		position += -event.relative
