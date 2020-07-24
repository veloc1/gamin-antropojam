extends TileMap

const TileAnimator = preload("res://src/effects/TileAnimator.gd")

const tile_animations = [
	["torch_1", "torch_2", "torch_3"],
	["forest_grass_1", "forest_grass_2"]
]
# you should also change tilenames accordingly in inspector:
# TileMap -> TileSet -> select tile -> change name -> hit enter

func _ready():
	for anim in tile_animations:
		var animator = TileAnimator.new()
		add_child(animator)
		animator.set_animation(self, anim)
