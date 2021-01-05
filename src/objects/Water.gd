tool
extends Area2D

var old_shape_dims

func _ready():
	connect("body_entered", self, "on_body_entered")
	connect("body_exited", self, "on_body_exited")
	
	set_tiles()
	print(get_children())

func on_body_entered(body):
	if body.is_in_group("player"):
		body.enter_to_area(self)
		play_sound()

func on_body_exited(body):
	if body.is_in_group("player"):
		body.exit_from_area(self)
		play_sound()

func play_sound():
	Sounds.play_sound("splash")

func set_tiles():
	$TileMap.clear()
	
	var dims = $CollisionShape2D.shape.extents
	
	var tile = 0 # water tile
	var tile_x = 0
	for x in range(-dims.x, dims.x, 32):
		var y = (-dims.y) / 32
		$TileMap.set_cell(x / 32, y, tile, false, false, false, Vector2(tile_x, 0))
		tile_x += 1
		if tile_x > 3: # 4 autotiles
			tile_x = 0
	for x in range(-dims.x, dims.x, 32):
		for y in range(-dims.y + 32, dims.y, 32):
			$TileMap.set_cell(x / 32, y / 32, tile, false, false, false, Vector2(4, 0))

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
