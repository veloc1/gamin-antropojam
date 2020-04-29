extends IdleState
class_name AttackState

func _ready():
	animation.connect("frame_changed", self, "on_frame_changed")
	animation.connect("animation_finished", self, "on_animation_finished")

	set_active(true)

func _exit_tree():
	animation.disconnect("frame_changed", self, "on_frame_changed")
	animation.disconnect("animation_finished", self, "on_animation_finished")

func move_left():
	look_left()
	set_velocity(-run_speed, get_velocity().y)

func move_right():
	look_right()
	set_velocity(run_speed, get_velocity().y)

func still():
	set_velocity(0, get_velocity().y)

func attack():
	pass

func attacked(_from_left):
	pass

func get_animation_name():
	return "attack"

func on_frame_changed():
	if animation.frame == 2:
		movement.get_component("Attack").attack()

func on_animation_finished():
	set_active(false)
