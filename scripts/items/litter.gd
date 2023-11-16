extends Grabbable

var items_array = []
@export var usage_factor = 2.0

func _physics_process(delta):
	super(delta)
	queue_redraw()

func _draw():
	for item in items_array:
		if item.usage != 0:
			draw_dashed_line(Vector2.ZERO, item.global_position - global_position, Color("00693a"), 20, 10)


func _on_litter_area_body_entered(body):
	# Item entered area
	if body.is_in_group("grabbables"):
			if body.item:
				# If already in array, cancel
				if items_array.find(body) != -1:
					return
				items_array.append(body)
				# Divide item usage
				body.divide_usage(usage_factor)


func _on_litter_area_body_exited(body):
	# Item exited area
	if body.is_in_group("grabbables"):
		if body.item:
			items_array.erase(body)
			body.reset_usage()
