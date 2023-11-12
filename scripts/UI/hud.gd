extends Control

# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	# Connect signals
	PowerManager.power_changed.connect(change_power)
	PowerManager.usage_changed.connect(change_usage)
	PowerManager.game_reset.connect(reset)
	
func change_power():
	$Topbar/PowerPanel/HBoxContainer/PowerLabel.text = str(floor(PowerManager.power))
	
func change_usage():
	$Topbar/UsagePanel/HBoxContainer/UsageLabel.text = str((PowerManager.usage))
	
func reset():
	change_power()
	change_usage()

func _on_shop_button_pressed():
	$shop.toggle_shop()
