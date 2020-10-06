tool
extends Area2D


func _ready():
	connect("body_entered", self, "on_body_entered")

func _process(_delta):
	update()

func on_body_entered(body):
	if body.is_in_group("player"):
		pass

func _draw():
	if Engine.editor_hint:
		var dims = $CollisionShape2D.shape.extents
		draw_rect(Rect2(-dims.x, -dims.y, dims.x * 2, dims.y * 2), Color.red)

		var rp = $RespawnPoint.position
		draw_circle(Vector2(rp.x, rp.y), 4, Color.green)

		draw_line(Vector2(0, 0), Vector2(rp.x, rp.y), Color.green, 3)
