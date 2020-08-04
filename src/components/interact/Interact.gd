extends Component
class_name Interact

export(NodePath) var interact_area_node

onready var interact_area

var bodies = []

func _ready():
	interact_area = get_node(interact_area_node)
	interact_area.connect("body_entered", self, "on_body_entered")
	interact_area.connect("body_exited", self, "on_body_exited")
	interact_area.connect("area_entered", self, "on_body_entered")
	interact_area.connect("area_exited", self, "on_body_exited")

func look_left():
	if interact_area.position.x > 0:
		interact_area.position.x = -interact_area.position.x

func look_right():
	if interact_area.position.x < 0:
		interact_area.position.x = -interact_area.position.x

func interact(player):
	for b in bodies:
		b.on_interaction(player)

func can_interact():
	if len(bodies) > 0:
		return true
	return false

func on_body_entered(body):
	if body.is_in_group("interactable"):
		bodies.append(body)

func on_body_exited(body):
	if body.is_in_group("interactable"):
		bodies.erase(body)
