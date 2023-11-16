extends Grabbable


# Movement Variables
var speed_min = 100
var speed_max = 250
var moves_min = 1
var moves_max = 2
var move_time_min = 1.0
var move_time_max = 2.0
var wait_time_min = 2
var wait_time_max = 4

var speed = 0
var moves = 0
var moves_current = 0
var is_moving = false

var direction = Vector2.ZERO

func _ready():
	super()
	$Timers/MoveWaitTimer.wait_time = randf_range(wait_time_min, wait_time_max)
	$Timers/MoveWaitTimer.start()
	
func _physics_process(delta):
	super(delta)
	
	# Handle movement
	if is_moving:
		var progress = $Timers/MoveTimer.time_left / $Timers/MoveTimer.wait_time
		var current_speed = (2 * (-pow(progress, 2) + progress)) * speed
		velocity = direction * current_speed
		# Slightly rotate
		if velocity.y != 0:
			rotation = (PI / 1500) * velocity.y
		else:
			rotation = 0
		move_and_slide()
		
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
