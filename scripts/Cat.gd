extends Grabbable

# Movement Variables
var speed_min = 500
var speed_max = 1000
var moves_min = 1
var moves_max = 3
var move_time_min = 1.0
var move_time_max = 2.5
var wait_time_min = 1.5
var wait_time_max = 3.0
var blink_time_min = 3
var blink_time_max = 6

var speed = 0
var moves = 0
var moves_current = 0

var direction = Vector2.ZERO

# Cat Flags
var is_moving = false
var in_generator = false
var in_scratcher = false

var power_time = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	super()
	$Timers/MoveWaitTimer.wait_time = randf_range(wait_time_min, wait_time_max)
	$Timers/MoveWaitTimer.start()
	$Timers/BlinkTimer.wait_time = randf_range(blink_time_min, blink_time_max)
	$Timers/BlinkTimer.start()
	$Timers/PowerGainTimer.wait_time = PowerManager.power_gain_time
	$Timers/PowerGainTimer.paused = true
	

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	super(delta)
	
	# Handle movement
	if is_moving:
		var progress = $Timers/MoveTimer.time_left / $Timers/MoveTimer.wait_time
		var current_speed = (2 * (-pow(progress, 2) + progress)) * speed
		velocity = direction * current_speed
		# Slightly rotate
		if velocity.x != 0:
			rotation = (PI / 1500) * velocity.x
		else:
			rotation = 0
		move_and_slide()
	# Handle powering
	if in_generator:
		power_time -= delta
	var power_progress = power_time / PowerManager.power_time_max
	if power_time > 0:
		$Textures/CatLight.modulate.a = power_progress + 0.1
	else:
		$Textures/CatLight.modulate.a = 0

func _on_pat_area_mouse_entered():
	# If not holding anything and available
	if MouseManager.grabbable == null and MouseManager.is_processing_input():
		charge()
		# Pat
		MouseManager.pat_cursor()
		
func charge():
	power_time += PowerManager.power_time_increment
	power_time = clampf(power_time, 0.0, PowerManager.power_time_max)

func _on_move_wait_timer_timeout():
	# New set of moves
	is_moving = true
	moves = randi_range(moves_min, moves_max)
	moves_current = 0
	new_move()

func _on_move_timer_timeout():
	# New move
	if moves_current <= moves:
		new_move()
	else:
		is_moving = false
		$Timers/MoveWaitTimer.wait_time = randf_range(wait_time_min, wait_time_max)
		$Timers/MoveWaitTimer.start()
		

func new_move():
	# Get possible directions
	var direction_quadrants = [0, 1, 2, 3] # Top, Bottom, Left, Right
	if $Raycasts/RayCastTop.is_colliding():
		direction_quadrants.erase(0)
		#print("top")
	if $Raycasts/RayCastBottom.is_colliding():
		direction_quadrants.erase(1)
		#print("bottom")
	if $Raycasts/RayCastLeft.is_colliding():
		direction_quadrants.erase(2)
		#print("left")
	if $Raycasts/RayCastRight.is_colliding():
		direction_quadrants.erase(3)
		#print("right")
	# New direction and speed
	if len(direction_quadrants) != 0:
		var direction_quadrant = direction_quadrants[randi_range(0, len(direction_quadrants)) - 1]
		match direction_quadrant:
			0:
				# Top
				direction = Vector2.UP.rotated(deg_to_rad(randi_range(-90, 90)))
			1:
				# Bottom
				direction = Vector2.UP.rotated(deg_to_rad(randi_range(90, 270)))
			2:
				# Left
				direction = Vector2.UP.rotated(deg_to_rad(randi_range(180, 360)))
			3:
				# Right
				direction = Vector2.UP.rotated(deg_to_rad(randi_range(0, 180)))
		direction = Vector2.UP.rotated(deg_to_rad(randi_range(0, 360)))
	speed = randi_range(speed_min, speed_max)
	
	moves_current += 1
	$Timers/MoveTimer.wait_time = randf_range(move_time_min, move_time_max)
	$Timers/MoveTimer.start()

func _on_power_gain_timer_timeout():
	# Gain power
	if power_time > 0:
		PowerManager.change_power(PowerManager.power_gain)
		SpawnManager.create_popup(global_position, load("res://textures/UI/power.png"), str(PowerManager.power_gain))


func _on_charge_area_area_entered(area):
	# Entered generator
	if area.is_in_group("generator"):
		in_generator = true
		$Timers/PowerGainTimer.paused = false


func _on_charge_area_area_exited(area):
	# Exited generator
	if area.is_in_group("generator"):
		in_generator = false
		$Timers/PowerGainTimer.paused = true


func _on_blink_timer_timeout():
	$Textures/CatSprite.stop()
	$Textures/CatSprite.play("eyes_closed")
	$Textures/CatHighlights.stop()
	$Textures/CatHighlights.play("eyes_closed")
