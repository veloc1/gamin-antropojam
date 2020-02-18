extends Area2D

signal sphere_pickup

func _on_sphere_body_entered(body):
  if body.is_in_group("player"):
    self.queue_free()
    emit_signal("sphere_pickup")
