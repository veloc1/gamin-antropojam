tool
extends Area2D

export(String) var level_name

func _ready():
	connect("body_entered", self, "on_body_entered")

func _process(_delta):
	update()

func on_body_entered(body):
	if body.is_in_group("player"):
		SceneChanger.change_scene("res://src/levels/%s.tscn" % level_name)

func _draw():
	if Engine.editor_hint:
		draw_rect(Rect2(-16, -16, 32, 32), Color.darkgoldenrod)

