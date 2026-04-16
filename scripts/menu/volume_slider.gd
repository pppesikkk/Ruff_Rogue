extends HSlider

@export var bus_name: String
var bus_index: int

func _ready() -> void:
	bus_index = AudioServer.get_bus_index(bus_name)
	
	# If Global has a saved value, use it. Otherwise, use current bus volume.
	if Global.config.has_section_key("audio", bus_name):
		value = Global.config.get_value("audio", bus_name)
	else:
		value = db_to_linear(AudioServer.get_bus_volume_db(bus_index))
		
	value_changed.connect(_on_value_changed)

func _on_value_changed(new_value: float) -> void:
	# 1. Update the actual audio server
	AudioServer.set_bus_volume_db(bus_index, linear_to_db(new_value))
	
	# 2. Tell Global to save this value
	Global.save_audio_setting(bus_name, new_value)
