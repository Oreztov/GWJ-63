extends Node

# Initial Variables
const power_init = 0

# Game Variables
var power = power_init

# Signals
signal power_changed
signal game_reset

# Reset game values to initial values
func reset():
	power = power_init
	
func change_power(value):
	power += value
	power_changed.emit()
