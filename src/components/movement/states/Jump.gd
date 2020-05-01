extends IdleState
class_name JumpState

func _ready():
	set_velocity(get_velocity().x, jump_speed)
	ghost_jump_timer.stop()
	set_active(true)

func jump():
	pass

func move_left():
	look_left()
	set_velocity(-run_speed, get_velocity().y)

func move_right():
	look_right()
	set_velocity(run_speed, get_velocity().y)

func still():
	set_velocity(0, get_velocity().y)

func attack():
	change_state("attack")

func _physics_process(_delta):
	if body.is_on_floor() and get_velocity().y >= 0:
		set_active(false)
		change_state("idle")
	else:
		set_active(true)


func get_animation_name():
	return "jump"
