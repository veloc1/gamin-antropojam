extends KinematicBody2D

const SporesExplosion = preload("res://src/effects/MushroomSporesExplosion.tscn")
const FireExplosion = preload("res://src/effects/MushroomFireExplosion.tscn")

const STATES = ["idle", "move_left", "move_right", "boom"]

onready var movement = $Components/Movement

export var is_spores_mushroom = false

var is_moving_left = true
var state = "idle"

func _ready():
	$Timer.connect("timeout", self, "on_timer_timeout")

	$DamageArea.connect("body_entered", self, "on_body_entered")
	$SporesTrigger.connect("body_entered", self, "on_body_entered_in_spores_trigger")

func _physics_process(_delta):
	if state == "move_left":
		movement.move_left()
		#$WallSensor.look_left()
	elif state == "move_right":
		movement.move_right()
		#$WallSensor.look_right()
	elif state == "idle":
		movement.still()
	elif state == "boom":
		# do nothing
		pass

	#if $WallSensor.on_wall():
	#	is_moving_left = !is_moving_left
	#	$WallSensor.skip_until_exit()

func on_timer_timeout():
	_change_state()

func _change_state():
	var new_state_index = rand_range(0, 3)
	state = STATES[new_state_index]

func on_body_entered(body):
	if body.is_in_group("player"):
		body.attacked(self)


func on_body_entered_in_spores_trigger(body):
	if body.is_in_group("player"):
		state = "boom"
		$Timer.disconnect("timeout", self, "on_timer_timeout")

		movement.stop()
		movement.idle()
		movement.still()

		$ExplosionAnimationPlayer.play("boom")

func add_explosion():
	var explosion = null
	if is_spores_mushroom:
		explosion = SporesExplosion.instance()
	else:
		explosion = FireExplosion.instance()
	get_parent().add_child(explosion)

	explosion.position = position
	explosion.play()

func reset_movement():
	$Timer.connect("timeout", self, "on_timer_timeout")


func remove_mushroom():
	if not is_spores_mushroom:
		queue_free()
