extends State
class_name IdleState

onready var ghost_jump_timer

func _ready():
	ghost_jump_timer = Timer.new()
	ghost_jump_timer.wait_time = 0.2
	add_child(ghost_jump_timer)

func can_jump():
	return body.is_on_floor() or ghost_jump_timer.time_left > 0

func jump():
	change_state("jump")

func move_left():
	look_left()
	change_state("walk")

func move_right():
	look_right()
	change_state("walk")

func still():
	set_velocity(0, get_velocity().y)

func attack():
	change_state("attack")

func attacked(from_left):
	change_state("attacked", {"from_left": from_left})

func _physics_process(_delta):
	if body.is_on_floor():
		ghost_jump_timer.start()

func get_animation_name():
	return "idle"
