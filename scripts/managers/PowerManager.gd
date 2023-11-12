extends Node2D

# Initial Variables
const power_init = 50.0
const usage_init = 0.5

# Game Variables
var power = power_init
var usage = usage_init # power per second

# Initial Cat Power variables
const power_gain_init = 1
const power_gain_time_init = 0.5
const power_time_max_init = 2.5
const power_time_increment_init = 0.25

# Cat Power variables
var power_gain = power_gain_init
var power_gain_time = power_gain_time_init
var power_time_max = power_time_max_init
var power_time_increment = power_time_increment_init



# Signals
signal power_changed
signal usage_changed
signal game_reset

func _ready():
	reset()
	$UsageTimer.start()

# Reset game values to initial values
func reset():
	power = power_init
	power_changed.emit()
	usage = usage_init
	usage_changed.emit()
	
func change_power(value):
	power += value
	power_changed.emit()
	
func change_usage(value):
	usage += value
	usage_changed.emit()

func _on_usage_timer_timeout():
	change_power(-usage)
