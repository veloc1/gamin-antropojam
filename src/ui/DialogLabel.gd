tool
extends Control

export(String, MULTILINE) var text = "" setget set_text

onready var tween = $Tween
onready var label = $MarginContainer/DialogLabel
onready var bg = $NinePatchRect

func _ready():
	start()
	if not Engine.editor_hint:
		var timer = get_tree().create_timer(3)
		timer.connect("timeout", self, "on_end_timer_timeout")

func start():
	label.text = text
	label.percent_visible = 0
	var duration = len(text) / 15.0
	duration = max(duration, 0.5) # set minimum duration to second number

	tween.interpolate_property(label, "percent_visible", 0, 1.0, duration, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	tween.start()

	bg.rect_size = Vector2(label.rect_size.x + label.rect_position.x, label.rect_size.y + label.rect_position.x * 2)

func set_text(new_text):
	text = new_text
	if label:
		label.text = text

func on_end_timer_timeout():
	queue_free()
