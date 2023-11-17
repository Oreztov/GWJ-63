extends Control

func _on_close_button_pressed():
	toggle_guide()

func toggle_guide():
	visible = !visible
