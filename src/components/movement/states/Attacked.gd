extends IdleState
class_name AttackedState

export (Vector2) var default_impact = Vector2(120, -400)

onready var from_left: bool
onready var impact_force = Vector2()
onready var timer

func _ready():
	from_left = params["from_left"]
	impact_force.y = default_impact.y
	if from_left:
		impact_force.x = default_impact.x
	else:
		impact_force.x = -default_impact.x
	set_velocity(impact_force.x, impact_force.y)
	set_active(true)

	timer = Timer.new()
	add_child(timer)
	timer.wait_time = 0.3
	timer.connect("timeout", self, "on_timeout")
	timer.start()


func can_jump():
	if not is_active():
		return .can_jump()

func jump():
	if not is_active():
		.jump()

func move_left():
	if not is_active():
		.move_left()

func move_right():
	if not is_active():
		.move_right()

func still():
	if not is_active():
		.still()

func attack():
	if not is_active():
		.attack()

func attacked(_from_left):
	pass

func on_timeout():
	set_active(false)

func _physics_process(_delta):
	if timer.time_left > 0:
		set_active(true)
	else:
		set_active(false)
	if impact_force.x != 0:
		# set_velocity(get_velocity().x + impact_force.x, get_velocity().y + impact_force.y)
		set_velocity(impact_force.x, impact_force.y)
		impact_force.x = lerp(impact_force.x, 0, 0.05)
		impact_force.y = lerp(impact_force.y, 0, 0.2)

func get_animation_name():
	return "stun"
