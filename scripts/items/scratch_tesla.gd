extends Grabbable

var cats_array = []

func _physics_process(delta):
	super(delta)
	queue_redraw()

func _on_charge_area_body_entered(body):
	# Cat entered area
	if body.is_in_group("cats"):
		# If already in array, cancel
		if cats_array.find(body) != -1:
			return
		cats_array.append(body)

func _draw():
	for cat in cats_array:
		draw_dashed_line(Vector2.ZERO, cat.global_position - global_position, Color.AQUA, 20, 10)

func _on_charge_area_body_exited(body):
	# Cat exited area
	if body.is_in_group("cats"):
		cats_array.erase(body)
	

func _on_charge_timer_timeout():
	for cat in cats_array:
		cat.charge()
