extends Node2D

var TransitEffect = preload("res://src/ui/TransitEffect.tscn")

var current_scene = null
var new_scene_path
var effect

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)


func change_scene(path, spawn_point):
	# This function will usually be called from a signal callback,
	# or some other function in the current scene.
	# Deleting the current scene at this point is
	# a bad idea, because it may still be executing code.
	# This will result in a crash or unexpected behavior.

	# The solution is to defer the load to a later time, when
	# we can be sure that no code from the current scene is running:

	call_deferred("_deferred_goto_scene", path, spawn_point)


func _deferred_goto_scene(path, spawn_point):
	new_scene_path = path

	effect = TransitEffect.instance()
	get_parent().add_child(effect)
	effect.connect("entered", self, "on_transition_entered", [spawn_point])
	effect.connect("exited", self, "on_transition_exited")

	#effect.rect_position = Vector2(-160, -120)

	effect.enter_transition()


func on_transition_entered(spawn_point):
	# It is now safe to remove the current scene
	current_scene.free()

	# Load the new scene.
	var s = ResourceLoader.load(new_scene_path)

	# Instance the new scene.
	current_scene = s.instance()

	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)

	current_scene.place_player_to_spawn(spawn_point)

	effect.exit_transition()


func on_transition_exited():
	effect.queue_free()
	new_scene_path = null
