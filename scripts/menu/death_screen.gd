extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _on_main_menu_pressed() -> void:
	Bgm.stop()
	BgmMenu.play()
	Global.goto_scene("res://scenes/main_menu.tscn")
	Global.scene_history.clear()
