extends Node2D

var is_broken = false

func _ready():
	$Area2D.connect("body_entered", self, "on_body_enters_in_area")
	$AnimationPlayer.connect("animation_finished", self, "on_animation_finished")

	$Base.hide()
	$Part.hide()
	$Full.show()

func broke():
	$AnimationPlayer.play("shake")

func on_body_enters_in_area(body):
	if is_broken:
		return

	if body.is_in_group("player"):
		is_broken = true
		broke()

func on_animation_finished(_anim):
	$Full.hide()
	$Base.show()
	$Part.show()
	$Part.fall()
