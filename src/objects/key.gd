extends Area2D

signal key_pickup


func _on_key_body_entered(body):
  if body.is_in_group("player"):
    self.queue_free()
    emit_signal("key_pickup")
