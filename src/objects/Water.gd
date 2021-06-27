tool
extends Area2D

const Splash = preload("res://src/effects/Splash.tscn")

var old_shape_dims

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")

	connect("area_exited", self, "on_area_exited")

	set_tiles()

func on_body_entered(body):
	if body.is_in_group("player"):
		body.enter_to_area(self)
		play_sound()

		body.set_in_water(true)

		var splash = Splash.instance()
		splash.position.x = body.position.x
		splash.position.y = body.position.y # + 6
		get_parent().add_child(splash)

func on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_from_area(self)
		play_sound()

		body.set_in_water(false)

func play_sound():
	Sounds.play_sound("Splash")

func set_tiles():
	$TileMap.clear()

	var dims = $CollisionShape2D.shape.extents

	var tile = 0 # water tile
	var tile_x = 0
	for x in range(-dims.x, dims.x, 32):
		var y = round((-dims.y) / 32.0)
		$TileMap.set_cell(round(x / 32.0), y, tile, false, false, false, Vector2(tile_x, 0))
		tile_x += 1
		if tile_x > 3: # 4 autotiles
			tile_x = 0
	for x in range(-dims.x, dims.x, 32):
		for y in range(-dims.y + 32, dims.y, 32):
			$TileMap.set_cell(round(x / 32.0), round(y / 32.0), tile, false, false, false, Vector2(4, 0))

func _process(_delta):
	var new_dims = Vector2($CollisionShape2D.shape.extents.x, $CollisionShape2D.shape.extents.y)
	if old_shape_dims and (old_shape_dims.x != new_dims.x or old_shape_dims.y != new_dims.y):
		set_tiles()
		old_shape_dims = new_dims

		update()

func _draw():
	if Engine.editor_hint:
		pass
		#var dims = $CollisionShape2D.shape.extents
		#var p = $CollisionShape2D.position
		#draw_rect(Rect2(-dims.x + p.x, -dims.y + p.y, dims.x * 2, dims.y * 2), Color.red)


func on_area_exited(area):
	if area.is_in_group("bubble"):
		area.get_parent().queue_free()
