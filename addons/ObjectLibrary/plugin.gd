tool
extends EditorPlugin

var Preview = load("res://addons/ObjectLibrary/Preview.tscn")

var dock
var preview

var is_editing_level:bool = false
var is_exiting = false # if we don't track exit status - there will be stack overflow on_tree_changed

func _enter_tree():
	get_tree().connect("tree_changed", self, "on_tree_changed")

func _exit_tree():
	is_exiting = true
	remove_dock()
	remove_preview()

func on_tree_changed():
	if is_exiting:
		return

	var is_level_opened = get_tree().edited_scene_root is Level
	if is_level_opened != is_editing_level:
		is_editing_level = is_level_opened
		if is_editing_level:
			add_dock()
			add_preview()
		else:
			remove_dock()
			remove_preview()

func _input(event):
	if event is InputEventMouseButton:
		if event.button_index == BUTTON_LEFT and not event.pressed:
			stop_drag()

func add_dock():
	dock = load("res://addons/ObjectLibrary/ObjectsDock.tscn").instance()
	dock.set_plugin(self)
	add_control_to_dock(DOCK_SLOT_LEFT_UR, dock)

func add_preview():
	preview = Preview.instance()
	get_tree().root.call_deferred("add_child", preview)

func remove_dock():
	if dock:
		remove_control_from_docks(dock)
		dock.queue_free()
		dock = null

func remove_preview():
	if preview:
		get_tree().root.remove_child(preview)
		preview.queue_free()
		preview = null

func start_drag(item):
	preview.set_item(item)

func stop_drag():
	if preview and preview.has_item():
		var item = preview.get_item()
		preview.set_item(null)

		var instance = item.scene.instance()

		var level = get_tree().edited_scene_root
		if item.category:
			var category = level.find_node(item.category)
			if category == null:
				category = Node2D.new()
				level.add_child(category)
				category.set_owner(level)
				category.name = item.category
				if level.get_child_count() > 5:
					level.move_child(category, 5)

			category.add_child(instance)
		else:
			level.add_child(instance)

		instance.set_owner(level)

		instance.position = level.get_local_mouse_position()
		instance.position.x = round(instance.position.x)
		instance.position.y = round(instance.position.y)

		var selection = get_editor_interface().get_selection()
		selection.clear()
		selection.add_node(instance)

