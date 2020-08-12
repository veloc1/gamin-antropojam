extends Node2D
class_name State

var animation: AnimatedSprite
var body: KinematicBody2D
var movement
var _is_active = false
var run_speed: int
var jump_speed: int
var params

func _ready():
	if animation.animation != get_animation_name():
		animation.play(get_animation_name())

func look_right():
	animation.flip_h = false

func look_left():
	animation.flip_h = true

func setup(
	parent_movement,
	animation_sprite: AnimatedSprite,
	kinematic_body: KinematicBody2D,
	move_speed,
	jump_value,
	params_dict
):
	animation = animation_sprite
	body = kinematic_body
	movement = parent_movement
	run_speed = move_speed
	jump_speed = jump_value
	params = params_dict

func change_state(name, params_dict=null):
	movement.set_state(name, params_dict)

func can_jump():
	return false

func jump():
	pass

func move_left():
	pass

func move_right():
	pass

func still():
	pass

func stop():
	pass

func attack():
	pass

func attacked(_from_left):
	pass

func is_active():
	return _is_active

func set_active(active):
	# print("Set active " + str(active))
	_is_active = active

func get_animation_name():
	return null

func get_velocity():
	return movement.get_velocity()

func set_velocity_vec(new_velocity):
	movement.set_velocity(new_velocity)

func set_velocity(x, y):
	movement.set_velocity(Vector2(x, y))
