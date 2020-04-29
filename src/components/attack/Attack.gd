extends Component
class_name Attack, "res://assets/editor/attack.png"

export(NodePath) var attack_area_node

onready var attack_area

var bodies = []

func _ready():
	attack_area = get_node(attack_area_node)
	attack_area.connect("body_entered", self, "on_body_entered")
	attack_area.connect("body_exited", self, "on_body_exited")
	attack_area.connect("area_entered", self, "on_body_entered")
	attack_area.connect("area_exited", self, "on_body_exited")

func look_left():
	if attack_area.position.x > 0:
		attack_area.position.x = -attack_area.position.x

func look_right():
	if attack_area.position.x < 0:
		attack_area.position.x = -attack_area.position.x

func attack():
	for b in bodies:
		b.attacked(attack_area)

func on_body_entered(body):
	if body.is_in_group("attackable"):
		bodies.append(body)

func on_body_exited(body):
	if body.is_in_group("attackable"):
		bodies.erase(body)
