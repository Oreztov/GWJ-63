extends Node2D

@export var area_name = "bruh"
@export var unlocked = false
@export var areas_to_unlock = 0
@export var available = true
@export var cat_colors: Array[CompressedTexture2D]

@onready var locked_text_init = $CanvasLayer/Control/Locked.tooltip_text

# Called when the node enters the scene tree for the first time.
func _ready():
	
	PowerManager.area_cost_updated.connect(update_cost)
	
	$Background.visible = unlocked
	$LevelBounds/LevelBlock.disabled = unlocked
	if unlocked:
		unlock()
	$CanvasLayer/Control/VBoxContainer/Label.text = area_name
	update_cost()
	$CanvasLayer/Control.position = global_position
	
func update_cost():
	areas_to_unlock -= 1
	if areas_to_unlock <= 0:
		available = true
	if not unlocked:
		if available:
			set_available()
			$CanvasLayer/Control/VBoxContainer/UncoverButton.text = "Uncover: " + str(PowerManager.area_cost)
			$CanvasLayer/Control/VBoxContainer/HBoxContainer/Label2.text = str(PowerManager.area_usage)
		else:
			set_locked()
	
func set_locked():
	$CanvasLayer/Control/Locked.show()
	$CanvasLayer/Control/Locked.tooltip_text = locked_text_init % areas_to_unlock
	$CanvasLayer/Control/VBoxContainer/UncoverButton.hide()
	$CanvasLayer/Control/VBoxContainer/HBoxContainer.hide()
	
func set_available():
	$CanvasLayer/Control/Locked.hide()
	$CanvasLayer/Control/VBoxContainer/UncoverButton.show()
	$CanvasLayer/Control/VBoxContainer/HBoxContainer.show()
	
func unlock():
	unlocked = true
	$Background.show()
	$LevelBounds/LevelBlock.disabled = true
	$CanvasLayer/Control/VBoxContainer/UncoverButton.hide()
	$CanvasLayer/Control/VBoxContainer/HBoxContainer/Label2.hide()
	PowerManager.area_unlocked.emit(self)
	SpawnManager.on_level_ready.emit(self, cat_colors)

func _on_uncover_button_pressed():
	if PowerManager.power >= PowerManager.area_cost:
		unlock()
