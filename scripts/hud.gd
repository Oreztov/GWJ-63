extends Control


# Called when the node enters the scene tree for the first time.
func _ready():
	reset()
	# Connect signals
	PowerManager.power_changed.connect(change_power)
	PowerManager.game_reset.connect(reset)
	
func change_power():
	$Topbar/PowerPanel/HBoxContainer/PowerLabel.text = str(PowerManager.power)
	
func reset():
	change_power()
