extends TileMap

const TileAnimator = preload("res://src/effects/TileAnimator.gd")

var tile_animations = [
	#["torch_1", "torch_2", "torch_3"],
	#["forest_grass_1", "forest_grass_2"]
	TileAnimator.new(
		"Castle_bg", 
		[
			Vector2(1, 3),
			Vector2(2, 3), 
			Vector2(3, 3)
		], 
		0.15),
	# Cave
	TileAnimator.new(
		"Cave_bg", 
		[
			Vector2(4, 4),
			Vector2(5, 4), 
			Vector2(6, 4),
			Vector2(5, 4), 
		], 
		0.15),
	TileAnimator.new(
		"Cave_bg", 
		[
			Vector2(3, 0),
			Vector2(4, 0), 
			Vector2(5, 0),
			Vector2(6, 0)
		], 
		0.15),
	TileAnimator.new(
		"Cave_bg", 
		[
			Vector2(3, 1),
			Vector2(4, 1), 
			Vector2(5, 1),
			Vector2(6, 1)
		], 
		0.15),
	TileAnimator.new(
		"Cave_bg", 
		[
			Vector2(3, 2),
			Vector2(4, 2), 
			Vector2(5, 2),
			Vector2(6, 2)
		], 
		0.15),
	TileAnimator.new(
		"Cave_bg", 
		[
			Vector2(3, 3),
			Vector2(4, 3), 
			Vector2(5, 3),
			Vector2(6, 3)
		], 
		0.15),
		
	# Water
	TileAnimator.new(
		"Water", 
		[
			Vector2(0, 0),
			Vector2(1, 0), 
			Vector2(2, 0),
			Vector2(3, 0)
		], 
		0.1),
	TileAnimator.new(
		"Water", 
		[
			Vector2(1, 0),
			Vector2(2, 0), 
			Vector2(3, 0),
			Vector2(0, 0)
		], 
		0.1),
	TileAnimator.new(
		"Water", 
		[
			Vector2(2, 0),
			Vector2(3, 0), 
			Vector2(0, 0),
			Vector2(1, 0)
		], 
		0.1),
	TileAnimator.new(
		"Water", 
		[
			Vector2(3, 0),
			Vector2(0, 0), 
			Vector2(1, 0),
			Vector2(2, 0)
		], 
		0.1),
		
]
# you should also change tilenames accordingly in inspector:
# TileMap -> TileSet -> select tile -> change name -> hit enter

#func _ready():
#	for anim in tile_animations:
#		var animator = TileAnimator.new()
#		add_child(animator)
#		animator.set_animation(self, anim)


func _ready():
	for anim in tile_animations:
		add_child(anim)
