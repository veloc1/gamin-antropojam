tool
extends VBoxContainer

onready var label = $title
onready var texture = $TextureRect

var plugin
var item

func _ready():
	connect("mouse_entered", self, "on_hover")
	connect("mouse_exited", self, "on_unhover")
	connect("gui_input", self, "on_input")

func set_item(item):
	set_title(item.descriptive_name)
	set_image(item.icon)
	
	self.item = item

func set_title(title):
	label.text = title

func set_image(image):
	texture.texture = image

func on_hover():
	modulate.a = 0.5
	texture.rect_scale = Vector2.ONE * 1.2

func on_unhover():
	modulate.a = 1
	texture.rect_scale = Vector2.ONE

func on_input(event):
	if event is InputEventMouseButton:
		if event.button_index == 1 and event.pressed:
			plugin.start_drag(item)

func set_plugin(plugin):
	self.plugin = plugin
