extends Control

signal play_pressed
signal paused

var ingame = false

# Called when the node enters the scene tree for the first time.
func _ready():
	$ColorRect.hide()
	$guide.hide()
	if get_parent().name == "HUD":
		$buttons/PlayButton.text = "Resume!"
		ingame = true
		$ColorRect.show()

func toggle_menu():
	visible = !visible
	get_tree().paused = visible
	paused.emit(visible)
	if visible:
		MouseManager.menu_enter()
		AudioServer.set_bus_mute(3, true)
	else:
		MouseManager.menu_exit()
		AudioServer.set_bus_mute(3, false)

func _on_play_button_pressed():
	if not ingame:
		play_pressed.emit()
	else:
		toggle_menu()


func _on_help_button_pressed():
	$guide.toggle_guide()


func _on_setting_button_pressed():
	$settings.toggle_guide()


func _on_quit_button_pressed():
	get_tree().quit()
