extends Control

@onready var my_popup = $VBoxContainer/start_btn/PopupPanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_start_pressed() -> void:
	my_popup.popup_centered()
	
func _on_game_start_btn_pressed() -> void:
	BgmMenu.stop()
	Bgm.play()
	Global.load_next_level()

func _on_tutorial_btn_pressed() -> void:
	BgmMenu.stop()
	Bgm.play()
	Global.goto_scene("res://scenes/start.tscn")
	
func _on_cancel_btn_pressed() -> void:
	my_popup.hide()


func _on_options_pressed() -> void:
	Global.goto_scene("res://scenes/options.tscn")


func _on_quit_pressed() -> void:
	get_tree().quit()


func _on_button_pressed() -> void:
	Global.goto_scene("res://scenes/shop.tscn")
