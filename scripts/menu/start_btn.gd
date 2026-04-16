extends Button

@onready var popup_menu = $PopupPanel # Assumes PopupMenu is a child of the Button

func _on_pressed():
	# This centers the popup relative to the game window
	popup_menu.popup_centered()
