extends Area2D

var bodies = []
var skip_events = false

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

func look_left():
	if position.x > 0:
		position.x = -position.x

func look_right():
	if position.x < 0:
		position.x = -position.x

func on_body_entered(body):
	bodies.append(body)

func on_body_exited(body):
	bodies.erase(body)
	if len(bodies) == 0:
		skip_events = false

func on_wall():
	if skip_events:
		return false
	return len(bodies) > 0

func skip_until_exit():
	skip_events = true
