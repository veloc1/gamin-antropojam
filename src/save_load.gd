extends Node

func load_save():
  var c = get_config()
  return c
  
func get_video_magnifier():
  var c = get_config()
  return c.get_value('game', 'video_magnifier', 2)

func save(video_magnifier):
  var c = get_config()
  c.set_value('game', 'video_magnifier', video_magnifier) 
  c.save("user://settings.cfg")
  #var screen_width = config.get_value("display", "width", 1024)
  # Store a variable if and only if it hasn't been defined yet
  #if not config.has_section_key("audio", "mute"):
  #    config.set_value("audio", "mute", false)
  # Save the changes by overwriting the previous file
  #config.save("user://settings.cfg")

func get_config() -> ConfigFile:
  var config = ConfigFile.new()
  var err = config.load("user://settings.cfg")
  if err == OK:
    return config
  config.save("user://settings.cfg")
  return config
