extends PanelContainer

@export var power_cost = 10
@export var item: PackedScene = null

@export var quantity = 1
@export var cost_multiplier = 1.5

@export var unlocked = true
@export var areas_to_unlock = 1

signal item_bought

@onready var locked_text = $Locked.tooltip_text

# Called when the node enters the scene tree for the first time.
func _ready():
	update()
	PowerManager.restock_shop.connect(restock)
	$Locked.tooltip_text = locked_text % areas_to_unlock
	$Locked.visible = not unlocked

func buy():
	# Check if can buy
	if power_cost > PowerManager.power or quantity <= 0:
		return
	# Change power values
	PowerManager.change_power(-power_cost)
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
	if item != null:
		$VBoxContainer/TextureRect/UsageContainer/UsageLabel.text = str(item.instantiate().usage)
	else:
		$VBoxContainer/TextureRect/UsageContainer/UsageLabel.text = "0"
		
func update_locked():
	if not unlocked:
		areas_to_unlock -= 1
		$Locked.tooltip_text = locked_text % areas_to_unlock
		if areas_to_unlock <= 0:
			unlocked = true
			$Locked.hide()
	

func _on_button_pressed():
	buy()
	
func restock():
	if unlocked:
		quantity += 1
		update()
	else:
		update_locked()
