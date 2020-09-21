extends CanvasLayer

var monitors = []

func add_property_monitor(name, target, property_path: NodePath):
	var target_node = target.get_node(property_path)
	var actual_property_path = ":" + property_path.get_concatenated_subnames()

	monitors.append({
		"name": name,
		"object": target_node,
		"property": actual_property_path
	})

func add_method_monitor(name, target, method_name):
	monitors.append({
		"name": name,
		"object": target,
		"method": method_name
	})	

func _process(_delta):
	var text = ""
	
	text += formatted("FPS", Engine.get_frames_per_second())
	text += formatted("Static Memory", String.humanize_size(OS.get_static_memory_usage()))
	for monitor in monitors:
		var node = monitor["object"]
		if node and weakref(node).get_ref():
			if "property" in monitor:
				var property = node.get_indexed(monitor["property"])
				text += formatted(monitor["name"], property)
			if "method" in monitor:
				text += formatted(monitor["name"], node.call(monitor["method"]))
				
	$Label.text = text

func formatted(name, value):
	return name + ": " + str(value) + "\n"
