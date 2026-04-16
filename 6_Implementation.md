# Our spaghetti implementation & coding
## Controls
### Main menu
```
extends Control

@onready var my_popup = $VBoxContainer/start_btn/PopupPanel
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	my_popup.hide()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass
```
### Options
```
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
```

## Levels
### Tut. level hint keys
```
extends Area2D

@onready var label = $Label

func _ready():
	label.hide()

func _on_body_entered(body):
	if body.name == "Player":
		label.show()

func _on_body_exited(body):
	if body.name == "Player":
		label.hide()
```
## Game Physic
### Player movement
```
if not is_on_floor():
		velocity += get_gravity() * delta
		
	var attack_inp = Input.is_action_just_pressed("lmb")
	
	if attack_inp and not current_attack:
		start_attack()
	
	if not current_attack:
		if Input.is_action_just_pressed("jump") and is_on_floor():
			velocity.y = jump_height
			
		var direction = Input.get_axis("left", "right")
		if direction:
			velocity.x = direction * speed
			sprite.flip_h = (direction == -1)
			deal_damage.scale.x = 1 if direction > 0 else -1
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	move_and_slide()
```
### Enemy movement

```
func _physics_process(delta):
	# gravity
	if not is_on_floor():
		velocity.y += gravity * delta
	
	# patrol logic
	if points.size() > 0:
		var target = points[current_point_index]
		var direction = sign(target.x - global_position.x)
		
		if not floor_ray.is_colliding():
			velocity.x = 0
		else:
			velocity.x = direction * speed
			sprite.flip_h = direction < 0
			
			if direction != 0:
				floor_ray.position.x = abs(floor_ray.position.x) * direction

		if global_position.distance_to(target) < 10:
			current_point_index = (current_point_index + 1) % points.size()

	move_and_slide()
```
