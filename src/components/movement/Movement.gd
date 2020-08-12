extends Component
class_name Movement, "res://assets/editor/movement.png"

export(NodePath) var animated_sprite
export(NodePath) var kinematic_body

export (int) var gravity = 1200
export (int) var move_speed = 100
export (int) var jump_speed = -150

var move_speed_modifier = 1

var states = {}
var current_state: State = null
var velocity = Vector2(0, 0)
var is_double_jump_enabled = false

func _ready():
	states["idle"]=  IdleState
	states["walk"] = WalkState
	states["jump"] = JumpState
	states["attack"] = AttackState
	states["attacked"] = AttackedState

	set_state("idle")

func set_state(name, params=null):
	# print("Set state to " + name)

	if current_state != null:
		current_state.queue_free()

	if name in states:
		current_state = states[name].new()

		var spr = get_node(animated_sprite)
		var b = get_node(kinematic_body)
		var speed = move_speed * move_speed_modifier
		current_state.setup(self, spr, b, speed, jump_speed, params)

		current_state.name = name

		current_state.set_active(true)

		add_child(current_state)
	else:
		var m = "Cannot find state %s" % name
		print(m)
		push_warning(m)
		current_state = null

func _physics_process(delta):
	var b = get_node(kinematic_body)

	velocity.y += gravity * delta
	velocity = b.move_and_slide_with_snap(velocity, Vector2(0, 0), Vector2.UP, false, 4, 0.785398, false)

func can_jump():
	return current_state.can_jump()

func jump():
	current_state.jump()

func move_left():
	current_state.move_left()

func move_right():
	current_state.move_right()

func still():
	current_state.still()

func stop():
	current_state.stop()

func idle():
	if current_state.name != "idle":
		set_state("idle")

func attack():
	current_state.attack()

func attacked(from_left):
	current_state.attacked(from_left)

func is_active():
	return current_state.is_active()

func reset_active():
	current_state.set_active(false)

func set_velocity(new_velocity):
	velocity = new_velocity

func get_velocity():
	return velocity

func enable_double_jump():
	is_double_jump_enabled = true

func modify_speed(modifier):
	move_speed_modifier = modifier
