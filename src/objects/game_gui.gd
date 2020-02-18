extends CanvasLayer

func _ready():
  var save_load = get_node("/root/SaveLoad")
  var v = save_load.get_video_magnifier()
  scale = Vector2(v, v)
  
func on_spheres_changed(count):
  $spheres.text = "Spheres: %d" % count

func on_lives_changed(count):
  for i in $hearts.get_children():
    i.queue_free()
  for i in range(count):
    var node = $heart_template.duplicate()
    $hearts.add_child(node)
    node.position.x = i * 16 + 4
    node.position.y = 4
    
