extends Component
class_name Shooting, "res://assets/editor/shooting.png"

# var Bullet = preload("res://src/objects/bullet.tscn")

signal shoot(bullet, is_facing_right, shooter_position)

export(NodePath) var bullet_spawn_point

var is_facing_right = true
onready var bullet_spawn
onready var shoot_timer = $ShootTimer

func _ready():
	bullet_spawn = get_node(bullet_spawn_point)

	for level in get_tree().get_nodes_in_group("levels"):
		connect("shoot", level, "on_shoot")

func look_left():
	is_facing_right = false
	if bullet_spawn.position.x > 0:
		bullet_spawn.position.x = -bullet_spawn.position.x

func look_right():
	is_facing_right = true
	if bullet_spawn.position.x < 0:
		bullet_spawn.position.x = -bullet_spawn.position.x

func shoot():
	if shoot_timer.time_left > 0:
			return
	shoot_timer.start()

	# emit_signal("shoot", Bullet, is_facing_right, bullet_spawn.global_position)
