extends Control

var in_shop = true

# Called when the node enters the scene tree for the first time.
func _ready():
	toggle_shop()

func toggle_shop():
	in_shop = !in_shop
	visible = in_shop


func _on_close_button_pressed():
	toggle_shop()
