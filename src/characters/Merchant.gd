extends AnimatedSprite

const DialogLabel = preload("res://src/ui/DialogLabel.tscn")

var player_in_room = false
var show_dialog = true

func _ready():
	$HandsAnimationTimer.connect("timeout", self, "on_hands_animation_timer")
	connect("animation_finished", self, "on_animation_finished")

	$PlayerListener.connect("body_entered", self, "on_player_entered")
	$PlayerListener2.connect("body_entered", self, "on_player_entered")
	$DialogTimer.connect("timeout", self, "on_dialog_timer_timeout")

func _process(_delta):
	var player = get_parent().get_node("Player")
	var is_player_to_left = player.position.x < position.x
	if is_player_to_left:
		flip_h = false
	else:
		flip_h = true

func on_hands_animation_timer():
	play("hands")

func on_animation_finished():
	if animation == "hands":
		play("idle")
		$HandsAnimationTimer.wait_time = rand_range(2, 5)
		$HandsAnimationTimer.start()

func on_player_entered(body):
	var on_enter_texts = [
		"He-he",
		"Hewwo",
		"What's new?",
		"^_^"
	]
	var on_exit_texts = [
		"See you",
		"You will return..."
	]
	if body.is_in_group("player"):
		var dialog = DialogLabel.instance()
		dialog.set_position(Vector2(global_position.x - 48, global_position.y - 32), false)

		if not player_in_room:
			player_in_room = true

			dialog.text = on_enter_texts[randi() % len(on_enter_texts)]
		else:
			player_in_room = false

			dialog.text = on_exit_texts[randi() % len(on_exit_texts)]

		if show_dialog:
			get_tree().root.add_child(dialog)

			show_dialog = false
			$DialogTimer.start()
		else:
			dialog.queue_free()

func on_dialog_timer_timeout():
	show_dialog = true
