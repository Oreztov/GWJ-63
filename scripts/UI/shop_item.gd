extends PanelContainer

@export var power_cost = 10
@export var power_usage = 0.5
@export var item: PackedScene = null

signal item_bought


# Called when the node enters the scene tree for the first time.
func _ready():
	$VBoxContainer/Button.text = "Buy: " + str(power_cost)
	if power_usage == 0:
		$VBoxContainer/TextureRect/UsageContainer.hide()
	else:
		$VBoxContainer/TextureRect/UsageContainer/UsageLabel.text = str(power_usage)


func buy():
	# Check if can buy
	if power_cost > PowerManager.power:
		return
	# Change power values
	PowerManager.change_power(-power_cost)
	PowerManager.change_usage(power_usage)
	# Change UI elements
	$VBoxContainer/Button.disabled = true
	$VBoxContainer/Button.text = "Purchased!"
	$VBoxContainer/Button.icon = null
	# If an item, put item in hand
	if item != null:
		SpawnManager.spawn_grabbable_in_hand(item)
	


func _on_button_pressed():
	buy()
