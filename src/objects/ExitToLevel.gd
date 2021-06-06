tool
extends Area2D

export(String) var level_name
export(String) var spawn_name

onready var old_bounds

func _ready():
	connect("body_entered", self, "on_body_entered")
	old_bounds = $CollisionShape2D.shape.extents

func _process(_delta):
	if Engine.editor_hint:
		if $CollisionShape2D.shape.extents != old_bounds:
			update()
			old_bounds = $CollisionShape2D.shape.extents

func on_body_entered(body):
	if body.is_in_group("player"):
		SaveLoad.save_level()
		SaveLoad.save_new_player_location(level_name, spawn_name)
		SceneChanger.change_scene("res://src/levels/%s.tscn" % level_name, spawn_name)

func _draw():
	if Engine.editor_hint:
		var dims = $CollisionShape2D.shape.extents
		draw_rect(Rect2(-dims.x, -dims.y, dims.x * 2, dims.y * 2), Color.darkgoldenrod)

