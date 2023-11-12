extends Grabbable

@export var cat_power_increase = 1 

func _ready():
	super()
	PowerManager.power_gain += cat_power_increase
