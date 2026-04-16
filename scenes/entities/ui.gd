extends Control

@onready var coin_label = $UI/HBoxContainer/Label
@onready var health_bar = $UI/health_bar

func _ready():
	health_bar.max_value = Global.max_health
	health_bar.value = Global.health
	coin_label.text = str(Global.coin_count)
	
	Global.health_changed.connect(update_health_bar)
	Global.coin_count_changed.connect(update_label)

func update_max_health(amount):
	health_bar.max_value = amount

func update_label(amount):
	coin_label.text = str(amount)

func update_health_bar(amount):
	health_bar.value = amount
