tool
extends VBoxContainer

const Item = preload("res://addons/ObjectLibrary/Item.tscn")

onready var label = $Label
onready var grid = $GridContainer
var plugin

func set_section_name(new_name):
	label.text = new_name

func set_items(items):
	for item in items:
		var preview = Item.instance()
		grid.add_child(preview)
		preview.set_plugin(plugin)

		preview.set_item(item)

func set_plugin(plugin):
	self.plugin = plugin
