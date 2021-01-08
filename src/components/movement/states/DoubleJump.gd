extends IdleState
class_name DoubleJumpState

var lerp_value_acceleration = 0.1
var lerp_value_decceleration = 0.03

func _ready():
	_actual_jump()

func jump():
	if can_jump():
		_actual_jump()

func can_jump():
	return false

func move_left():
	look_left()
	var x = lerp(get_velocity().x, -run_speed, lerp_value_acceleration)
	set_velocity(x, get_velocity().y)

func move_right():
	look_right()
	var x = lerp(get_velocity().x, run_speed, lerp_value_acceleration)
	set_velocity(x, get_velocity().y)

func still():
	set_velocity(lerp(get_velocity().x, 0, lerp_value_decceleration), get_velocity().y)

func attack():
	change_state("attack")

func _physics_process(_delta):
	if body.is_on_floor() and get_velocity().y >= 0:
		set_active(false)
		change_state("idle")
	else:
		set_active(true)

func get_animation_name():
	return "double_jump"

func _actual_jump():
	Events.emit_signal("double_jump", body.position, animation.flip_h)
	
	set_velocity(get_velocity().x, jump_speed)
	ghost_jump_timer.stop()
	set_active(true)
