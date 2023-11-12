extends Node2D

# Initial Variables
const power_init = 50.0

# Game Variables
var power = power_init
var usage = 0.5 # power per second

# Signals
signal power_changed
signal game_reset

func _ready():
	$UsageTimer.start()

# Reset game values to initial values
func reset():
	power = power_init
	
func change_power(value):
	power += value
	power_changed.emit()

func _on_usage_timer_timeout():
	change_power(-usage)
