extends IdleState
class_name WalkState

func _ready():
	set_active(true)

func move_left():
	look_left()
	set_velocity(-run_speed, get_velocity().y)
	set_active(true)

func move_right():
	look_right()
	set_velocity(run_speed, get_velocity().y)
	set_active(true)

func still():
	set_velocity(lerp(get_velocity().x, 0, 0.1), get_velocity().y)	
	change_state("idle")

func get_animation_name():
	return "walk"
