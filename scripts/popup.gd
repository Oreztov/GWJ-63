extends Node2D

@onready var texture = null
@onready var text = null


func create():
	$Control/PopupTexture.texture = texture
	if text != null:
		$Control/PopupText.text = text
	else:
		$Control/PopupText.text = ""

func _on_animation_player_animation_finished(anim_name):
	queue_free()
