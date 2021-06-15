extends AnimatedSprite

const DialogLabel = preload("res://src/ui/DialogLabel.tscn")

var player
var player_in_room = false
var show_dialog = true

func _ready():
	$HandsAnimationTimer.connect("timeout", self, "on_hands_animation_timer")
	connect("animation_finished", self, "on_animation_finished")

	$PlayerListener.connect("body_exited", self, "on_player_exited1")
	$PlayerListener2.connect("body_exited", self, "on_player_exited2")
	$DialogTimer.connect("timeout", self, "on_dialog_timer_timeout")
	player = get_parent().get_parent().get_node("Player")

func _process(_delta):
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

func on_player_exited1(body):
	if body.is_in_group("player"):
		if body.global_position.x < $PlayerListener.global_position.x:
			player_in_room = false
		else:
			player_in_room = true
		greeet_or_goodbay_player()

func on_player_exited2(body):
	if body.is_in_group("player"):
		if body.global_position.x > $PlayerListener2.global_position.x:
			player_in_room = false
		else:
			player_in_room = true
		greeet_or_goodbay_player()

func greeet_or_goodbay_player():
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
	if player_in_room:
		say(_choice(on_enter_texts))
	else:
		say(_choice(on_exit_texts))

func on_item_bought():
	var vars = [
		"Nice choice"
	]
	say(_choice(vars))

func on_not_enough_money():
	var vars = [
		"Come back when\nyou have mune'h"
	]
	say(_choice(vars))


func say(text):
	var direction = ""
	if flip_h:
		direction = "right"
	else:
		direction = "left"

	var dialog = DialogLabel.instance()
	dialog.text = text

	var y_diff = len(text.split("\n")) * 18
	var y_pos = global_position.y - 16 - y_diff

	var symbols = 8 # in average message
	symbols = min(symbols, len(text))
	var symbol_width = 8 # in pixels
	var text_width = symbols * symbol_width
	var x_pos = global_position.x - 26

	if direction == "left":
		x_pos -= text_width / 2
	else:
		x_pos += text_width / 2
	dialog.set_position(Vector2(x_pos, y_pos), false)

	if show_dialog:
		get_tree().root.add_child(dialog)

		show_dialog = false
		$DialogTimer.start()
	else:
		dialog.queue_free()

func on_dialog_timer_timeout():
	show_dialog = true

func _get_dialog_direction():
	pass

func _choice(arr):
	return arr[randi() % len(arr)]
