tool
extends Control

const Section = preload("res://addons/ObjectLibrary/Section.tscn")

onready var container = $VBoxContainer

var plugin

func _ready():
	var sections = collect_sections("res://src")
	form_ui(sections)
	
func form_ui(sections):
	for section in sections:
		add_ui_section(section.descriptive_name, section.items)

func add_ui_section(section_name, items):
	var section = Section.instance()
	container.add_child(section)
	section.set_plugin(plugin)
	
	section.set_section_name(section_name)
	section.set_items(items)

func collect_sections(path):
	var sections = []
	var dir = Directory.new()
	if dir.open(path) == OK:
		dir.list_dir_begin()
		
		var section = null
		if dir.file_exists("SectionMeta.tres"):
			section = load(str(dir.get_current_dir(), '/', "SectionMeta.tres"))
			section.items.clear()
			sections.append(section)
		
		var file_name = dir.get_next()
		while file_name != "":
			if file_name == "." or file_name == "..":
				file_name = dir.get_next()
				continue
				
			if dir.current_is_dir():
				var inner_sections = collect_sections(str(dir.get_current_dir(), '/', file_name))
				sections = sections + inner_sections
			else:
				if section != null:
					if "Meta" in file_name and file_name != "SectionMeta.tres": 
						var meta = load(str(dir.get_current_dir(), '/', file_name))
						section.items.append(meta)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")
	
	return sections

func set_plugin(plugin):
	self.plugin = plugin
