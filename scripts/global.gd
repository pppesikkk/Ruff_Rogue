extends Node

const SAVE_PATH = "user://settings.cfg"
var config = ConfigFile.new()
var scene_history: Array[String] = []
var last_level_path: String = ""

var levels: Array[String] = [
	"res://scenes/levels/level_1.tscn",
	"res://scenes/levels/level_2.tscn",
	"res://scenes/levels/level_3.tscn",
	"res://scenes/levels/level_4.tscn"
]

signal coin_count_changed(new_amount)

var levels_passed : int = 0
var boss_level_frequency : int = 5
var coin_count : int = 0
var times_bought: int = 0


signal health_changed(new_health)

var max_health = 3.0 + (times_bought*0.5)
		
var health: float = 0:
	set(value):
		health = clampf(value, 0, max_health)
		health_changed.emit(health)


var damage : float = 20.0


func add_coin():
	coin_count += 1
	save_coins()
	coin_count_changed.emit(coin_count)

func is_tutor():
	var scene = get_tree().current_scene.scene_file_path
	
	if scene.ends_with("start.tscn"):
		goto_scene("res://scenes/main_menu.tscn")
		Global.health = max_health
		Bgm.stop()
		BgmMenu.play()
	else:
		load_next_level()

func is_prev_scene_menu() -> bool:
	if scene_history.size() > 0:
		return scene_history[-1].ends_with("main_menu.tscn")
	return false

func _ready():
	load_settings()
	load_coins()
	load_permanent_upgrades()
	
func save_coins():
	config.set_value("progression", "coin_count", coin_count)
	config.save(SAVE_PATH)
	
func save_upgrade_level(item_name: String, count: int):
	config.set_value("upgrades", item_name, count)
	config.save(SAVE_PATH)
	
func load_upgrade_level(item_name: String) -> int:
	# Reload the file to make sure we have the latest data
	var err = config.load(SAVE_PATH)
	if err != OK: return 0
	return config.get_value("upgrades", item_name, 0)

func load_coins():
	
	var err = config.load(SAVE_PATH)
	if err != OK: return
	
	coin_count = config.get_value("progression", "coin_count", 0)

func load_permanent_upgrades():
	times_bought = config.get_value("upgrades", "max_health_upgrade", 0)
	max_health = 3.0 + (times_bought * 0.5)
	health = max_health
	
func save_audio_setting(bus_name: String, value: float):
	config.set_value("audio", bus_name, value)
	config.save(SAVE_PATH)

func load_settings():
	var err = config.load(SAVE_PATH)
	if err != OK: return
	

	for bus in ["Master", "Music", "SFX"]:
		if config.has_section_key("audio", bus):
			var vol_linear = config.get_value("audio", bus)
			var bus_idx = AudioServer.get_bus_index(bus)
			if bus_idx != -1:
				AudioServer.set_bus_volume_db(bus_idx, linear_to_db(vol_linear))


func goto_scene(path: String):
	if get_tree().current_scene:
		scene_history.push_back(get_tree().current_scene.scene_file_path)
	
	_load_scene(path)


func go_back():
	if scene_history.size() > 0:
		var last_path = scene_history.pop_back()
		_load_scene(last_path)
	else:
		push_warning("Global.gd: No scenes left in history to go back to!")


func _load_scene(path: String):
	get_tree().change_scene_to_file.call_deferred(path)

func clear_history():
	scene_history.clear()
	

func goto_random_level():
	var current_level = get_tree().current_scene.scene_file_path
		
	var possible_levels = []
	for lvl in levels:
		if lvl != current_level:
			possible_levels.append(lvl)

	if possible_levels.size() > 0:
		var random_index = randi() % possible_levels.size()
		var selected_level = possible_levels[random_index]
		scene_history.append(current_level)
		
		return selected_level
	else:
		push_warning("Global.gd: No other levels available!")

func get_next_level_path():
	levels_passed += 1
	if levels_passed % boss_level_frequency == 0:
		Bgm.stop()
		BgmBoss.play()
		return "res://scenes/levels/boss_room_1.tscn"
	else:
		return goto_random_level()

func load_next_level():
	var path = get_next_level_path()
	goto_scene(path)

func die():
	health = float(max_health)
	goto_scene("res://scenes/levels/death_screen.tscn")
	BgmBoss.stop()
	Bgm.stop()
	BgmMenu.play()
