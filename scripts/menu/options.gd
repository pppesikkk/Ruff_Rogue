extends Control

@onready var back_button = $main_menu

func _ready() -> void:
	if Global.is_prev_scene_menu():
		back_button.visible = false


func _process(_delta: float) -> void:
	pass

func _on_back_to_menu_pressed() -> void:
	Global.go_back()


func _on_check_button_toggled(button_pressed) -> void:
	if button_pressed == true:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)



func _on_main_menu_pressed() -> void:
	Bgm.stop()
	BgmMenu.play()
	Global.goto_scene("res://scenes/main_menu.tscn")
	Global.scene_history.clear()
