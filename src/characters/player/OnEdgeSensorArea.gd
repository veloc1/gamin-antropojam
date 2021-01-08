extends Area2D

var bodies = []

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	#connect("area_entered", self, "on_body_entered")
	#connect("area_exited", self, "on_body_exited")

func look_left():
	if position.x > 0:
		position.x = -position.x

func look_right():
	if position.x < 0:
		position.x = -position.x

func can_interact():
	if len(bodies) > 0:
		return true
	return false

func on_body_entered(body):
	bodies.append(body)

func on_body_exited(body):
	bodies.erase(body)

func on_edge():
	return len(bodies) == 0
