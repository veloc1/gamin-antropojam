extends KinematicBody2D

onready var movement = $Components/Movement

var is_moving_left = false

func _physics_process(delta):
	if is_moving_left:
		movement.move_left()
		$WallSensor.look_left()
	else:
		movement.move_right()
		$WallSensor.look_right()
	
	if $WallSensor.on_wall():
		is_moving_left = !is_moving_left
		$WallSensor.skip_until_exit()
