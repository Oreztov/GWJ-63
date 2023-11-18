extends Node

@onready var cat = preload("res://scenes/cat.tscn")

@onready var popup = preload("res://scenes/UI/popup.tscn")

@onready var main_reference

signal on_level_ready

# Game Variables
const cat_spawn_init = 5
var cat_spawn = cat_spawn_init
var cat_spawn_increase = 1


# Called when the node enters the scene tree for the first time.
func _ready():
	on_level_ready.connect(level_ready)
	
func level_ready(level, cat_colors):
	for i in range(cat_spawn):
		spawn_cat(level, cat_colors)
	cat_spawn += cat_spawn_increase
	
func spawn_cat(level, cat_colors):
	var new_cat = cat.instantiate()
	new_cat.global_position = Vector2(randi_range(150, 1750), randi_range(150, 900))
	# Random cat color
	var new_texture = cat_colors[randi_range(0, len(cat_colors))-1]
	new_cat.get_node("Textures/CatSprite").material.set_shader_parameter("palette", new_texture)
	level.call_deferred("add_child", new_cat)
	
func spawn_grabbable_in_hand(item: PackedScene):
	var new_item: Grabbable = item.instantiate()
	# If already holding something, release
	if MouseManager.grabbable != null:
		MouseManager.grabbable.release()
	main_reference.call_deferred("add_child", new_item)
	if new_item.usage != 0:
		PowerManager.change_usage(new_item, new_item.usage)
	new_item.grab()
	
func create_popup(pos, texture, text):
	var new_popup = popup.instantiate()
	new_popup.global_position = pos
	new_popup.texture = texture
	new_popup.text = text
	new_popup.create()
	main_reference.call_deferred("add_child", new_popup)
