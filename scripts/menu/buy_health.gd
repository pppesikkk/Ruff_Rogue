extends Button

@export var base_cost: int = 2
@onready var price_label = $CenterContainer/HBoxContainer/Label

@onready var coin_label = $"../../coins/Label"
@onready var times_bought_text = $"../h_upg/Label"

func _ready():
	coin_label.text = str(Global.coin_count)
	
	Global.coin_count_changed.connect(update_label)
	
	times_bought_text.text = str(Global.times_bought)
	update_button_ui()

func update_label(amount):
	coin_label.text = str(amount)
	
func _on_pressed():
	if Global.times_bought >= 10:
		return
		
	var current_cost = calculate_cost()
	if Global.coin_count >= current_cost:
		Global.coin_count -= current_cost
		Global.times_bought += 1
		Global.coin_count_changed.emit(Global.coin_count)
		
		# Only use the helper function - it handles the config.save for you!
		Global.save_upgrade_level("max_health_upgrade", Global.times_bought)
		
		apply_purchase_effect()
		update_button_ui()
		Global.save_coins()
	else:
		$no_coins.play()

func apply_purchase_effect():
	Global.max_health += 0.5
	# Update the text showing how many times we bought it
	times_bought_text.text = str(Global.times_bought)
	$buy.play()

func calculate_cost() -> int:
	var times = 1.5 + (Global.times_bought * 0.5)
	return int(round(pow(base_cost, times)))

func update_button_ui():
	if Global.times_bought >= 10:
		price_label.text = "MAX"
		disabled = true # Gray out the button
		# Optional: Hide the coin icon if you want
		$HBoxContainer/TextureRect.hide() 
	else:
		price_label.text = str(calculate_cost())
