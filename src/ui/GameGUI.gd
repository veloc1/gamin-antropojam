extends CanvasLayer

func _ready():
	var save_load = get_node("/root/SaveLoad")
	var v = save_load.get_video_magnifier()
	scale = Vector2(v, v)

func on_spheres_changed(count):
	$Spheres.text = "Spheres: %d" % count

func on_keys_changed(count):
	$Keys.text = "Keys: %d" % count

func on_lives_changed(count):
	for i in $Hearts.get_children():
		i.queue_free()
	for i in range(count):
		var node = $HeartTemplate.duplicate()
		$Hearts.add_child(node)
		node.position.x = i * 16 + 4
		node.position.y = 4

