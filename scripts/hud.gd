extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	# Connect signals
	PowerManager.power_changed.connect(change_power)
	PowerManager.game_reset.connect(reset)
	
func change_power():
	$Topbar/PowerPanel/HBoxContainer/PowerLabel.text = str(floor(PowerManager.power))
	$Topbar/UsagePanel/HBoxContainer/UsageLabel.text = str((PowerManager.usage))
	
func reset():
	change_power()
