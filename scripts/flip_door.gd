extends Area2D

@onready var door = $Sprite2D

func _ready() -> void:
	door.flip_h = true

func _on_body_entered(body: Node2D) -> void:
	if body.name == "Player":
		Global.is_tutor()

func _process(_delta: float) -> void:
	pass
