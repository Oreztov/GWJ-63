extends Node2D

# Initial Variables
const power_init = 2550
const usage_init = 0

# Game Variables
var power = power_init
var usage = usage_init # power per second
var usage_users = {}
var power_min_factor = 100
var power_min = - usage * power_min_factor

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

# New Level Power Variables
const initial_area_cost = 250
var area_cost = initial_area_cost
var area_cost_multiplier = 2
var area_usage = 0.5
var area_usage_multiplier = 2
var areas_unlocked = 0

# Signals
signal power_changed
signal usage_changed
signal game_reset
signal area_unlocked
signal area_cost_updated
signal lost_power
signal regain_power
signal restock_shop

func _ready():
	reset()
	$UsageTimer.start()
	area_unlocked.connect(unlock_area)

# Reset game values to initial values
func reset():
	power = power_init
	power_changed.emit()
	usage = usage_init
	usage_changed.emit()
	
func change_power(value):
	power += value
	if power < power_min:
		power = power_min
	power_changed.emit()
	if power < 0:
		lost_power.emit()
	else:
		regain_power.emit()
	
func change_usage(user, value):
	# Change usage
	usage_users[user] = value
	# Calculate new usage
	usage = 0
	for _user in usage_users:
		usage += usage_users[_user]
	power_min = - usage * power_min_factor
	usage_changed.emit()

func _on_usage_timer_timeout():
	change_power(-usage)
	
func unlock_area(area):
	change_usage(area, area_usage)
	if areas_unlocked > 0:
		change_power(-area_cost)
		area_cost *= area_cost_multiplier
		area_usage *= area_usage_multiplier
		area_cost_updated.emit()
		restock_shop.emit()
	areas_unlocked += 1
	
