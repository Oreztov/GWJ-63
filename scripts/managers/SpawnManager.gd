extends Node

@onready var cat = preload("res://scenes/cat.tscn")
@onready var cat_colors: Array

@onready var popup = preload("res://scenes/UI/popup.tscn")

@onready var level_reference
@onready var main_reference

signal on_level_ready

# Game Variables
const cat_spawn_init = 7


# Called when the node enters the scene tree for the first time.
func _ready():
	cat_colors = get_files_in_folder("res://textures/cats/cat_colors", "png")
	on_level_ready.connect(level_ready)
	
func level_ready():
	for i in range(cat_spawn_init):
		spawn_cat()
	
func spawn_cat():
	var new_cat = cat.instantiate()
	new_cat.global_position = Vector2(randi_range(0, 1920), randi_range(0, 1080))
	# Random cat color
	var new_texture = cat_colors[randi_range(0, len(cat_colors))-1]
	new_cat.get_node("Textures/CatSprite").material.set_shader_parameter("palette", load(new_texture))
	level_reference.call_deferred("add_child", new_cat)
	
func spawn_grabbable_in_hand(item: PackedScene):
	var new_item: Grabbable = item.instantiate()
	# If already holding something, release
	if MouseManager.grabbable != null:
		MouseManager.grabbable.release()
	level_reference.call_deferred("add_child", new_item)
	new_item.grab()
	
func create_popup(pos, texture, text):
	var new_popup = popup.instantiate()
	new_popup.global_position = pos
	new_popup.texture = texture
	new_popup.text = text
	new_popup.create()
	main_reference.call_deferred("add_child", new_popup)
	
func get_files_in_folder(path, extension):
	var temp_array = []
	var dir = DirAccess.open(path)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			# Workaround for a Godot """"feature"""". Thanks Godot.
			file_name = file_name.trim_suffix(".remap")
			file_name = file_name.trim_suffix(".import")
			
			if not dir.current_is_dir() and file_name.get_extension() == extension:
				temp_array.append(path + "/" + file_name)
			file_name = dir.get_next()
		return temp_array
	else:
		print("Failed to open directory!")
		return
