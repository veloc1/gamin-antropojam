extends StaticBody2D

signal door_opened

var is_opened

func _ready():
  $opened.hide()

func open():
  $opened.show()
  $closed.hide()
  set_collision_layer_bit(0, false)
  set_collision_mask_bit(0, false)

func _on_door_area_body_entered(body):
  if is_opened:
    return
    
  if body.is_in_group("player"):
    if body.keys > 0:
      open()
      emit_signal("door_opened")
      is_opened = true
