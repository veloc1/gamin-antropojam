extends KinematicBody2D

const STATES = ["idle", "move_left", "move_right", "chasing"]

onready var movement = $Components/Movement

var is_moving_left = true
var state = "idle"

func _ready():
	$Timer.connect("timeout", self, "on_timer_timeout")

func _physics_process(_delta):
	if state == "move_left":
		movement.move_left()
		#$WallSensor.look_left()
	elif state == "move_right":
		movement.move_right()
		#$WallSensor.look_right()
	elif state == "idle":
		movement.still()

	#if $WallSensor.on_wall():
	#	is_moving_left = !is_moving_left
	#	$WallSensor.skip_until_exit()

func on_timer_timeout():
	_change_state()

func _change_state():
	var new_state_index = rand_range(0, 3)
	state = STATES[new_state_index]
