extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	# Connect signals
	PowerManager.power_changed.connect(change_power)
	PowerManager.usage_changed.connect(change_usage)
	PowerManager.game_reset.connect(reset)
	PowerManager.lost_power.connect(lose_power)
	PowerManager.regain_power.connect(regain_power)
	
	$Menu.hide()
	$Menu.paused.connect(on_pause)
	MouseManager.menu_exit()
	
func change_power():
	$Topbar/PowerPanel/HBoxContainer/PowerLabel.text = str(floor(PowerManager.power))
	
func change_usage():
	$Topbar/UsagePanel/HBoxContainer/UsageLabel.text = str((PowerManager.usage))
	
func reset():
	change_power()
	change_usage()

func on_pause(paused: bool):
	if paused:
		if $shop.in_shop:
			$shop.toggle_shop()
	$Topbar/ShopButton.disabled = paused

func lose_power():
	var tween = get_tree().create_tween()
	tween.tween_property($Blackout, "color", Color(1, 1, 1, 0.99), 1)

func regain_power():
	var tween = get_tree().create_tween()
	tween.tween_property($Blackout, "color", Color(1, 1, 1, 0), 1)

func _on_shop_button_pressed():
	$shop.toggle_shop()


func _on_menu_button_pressed():
	$Menu.toggle_menu()
