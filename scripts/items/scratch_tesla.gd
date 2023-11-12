extends Grabbable

var cats_array = []


func _on_charge_area_body_entered(body):
	# Cat entered area
	if body.is_in_group("cats"):
		# If already in array, cancel
		if cats_array.find(body) != -1:
			return
		cats_array.append(body)


func _on_charge_area_body_exited(body):
	# Cat exited area
	if body.is_in_group("cats"):
		cats_array.erase(body)
	

func _on_charge_timer_timeout():
	for cat in cats_array:
		cat.power_time += PowerManager.power_time_increment
		cat.power_time = clampf(cat.power_time, 0.0, PowerManager.power_time_max)
