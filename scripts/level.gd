extends Node2D

@export var area_name = "bruh"
@export var unlocked = false

# Called when the node enters the scene tree for the first time.
func _ready():
	
	PowerManager.area_cost_updated.connect(update_cost)
	
	$Clouds.visible = not unlocked
	if unlocked:
		unlock()
	$CanvasLayer/Control/VBoxContainer/Label.text = area_name
	update_cost()
	$CanvasLayer/Control.position = global_position
	
func update_cost():
	$CanvasLayer/Control/VBoxContainer/UncoverButton.text = "Uncover: " + str(PowerManager.area_cost)
	$CanvasLayer/Control/VBoxContainer/HBoxContainer/Label2.text = str(PowerManager.area_usage)
	
func unlock():
	unlocked = true
	$Clouds.hide()
	$CanvasLayer/Control/VBoxContainer/UncoverButton.hide()
	$CanvasLayer/Control/VBoxContainer/HBoxContainer/Label2.hide()
	PowerManager.area_unlocked.emit()
	SpawnManager.on_level_ready.emit(self)

func _on_uncover_button_pressed():
	if PowerManager.power >= PowerManager.area_cost:
		unlock()
