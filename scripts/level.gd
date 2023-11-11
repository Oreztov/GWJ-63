extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready():
	SpawnManager.level_reference = self
	
	SpawnManager.on_level_ready.emit()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
