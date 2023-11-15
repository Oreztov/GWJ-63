extends PanelContainer

@export var power_cost = 10
@export var power_usage = 0.5
@export var item: PackedScene = null

@export var quantity = 1
@export var cost_multiplier = 1.5

signal item_bought

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	PowerManager.restock_shop.connect(restock)

func buy():
	# Check if can buy
	if power_cost > PowerManager.power or quantity <= 0:
		return
	# Change power values
	PowerManager.change_power(-power_cost)
	PowerManager.change_usage(power_usage)
	power_cost *= cost_multiplier
	power_cost = round(power_cost)
	# Change UI elements
	quantity -= 1
	$VBoxContainer/TextureRect/UsageContainer/Quantity.text = "x" + str(quantity)
	update()
	# If an item, put item in hand
	if item != null:
		SpawnManager.spawn_grabbable_in_hand(item)

func update():
	if quantity <= 0:
		$VBoxContainer/Button.disabled = true
	else:
		$VBoxContainer/Button.disabled = false
	$VBoxContainer/Button.text = "Buy: " + str(power_cost)
	$VBoxContainer/TextureRect/UsageContainer/Quantity.text = "x" + str(quantity)
	$VBoxContainer/TextureRect/UsageContainer/UsageLabel.text = str(power_usage)
	

func _on_button_pressed():
	buy()
	
func restock():
	quantity += 1
	update()
