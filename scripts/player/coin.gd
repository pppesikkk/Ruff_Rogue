extends Area2D

func _on_body_entered(body: Node2D) -> void:

	if body.name == "Player":
		pickup()

func pickup():
	
	set_deferred("monitoring", false)
	
	Global.add_coin()
	
	$Sprite2D.visible = false
	set_deferred("monitoring", false)
	
	$pickup_sound.play()
	
	await $pickup_sound.finished
	queue_free()
