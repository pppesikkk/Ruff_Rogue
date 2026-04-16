extends CharacterBody2D

class_name Player

@onready var visual = $VisualPivot
@onready var sprite = $VisualPivot/AnimatedSprite2D

const speed = 250.0
const jump_height = -365.0
var was_in_air = false
var highest_y_point = 0.0
@export var high_fall_threshold = 200

@onready var collision_r = $CollisionRight
@export var respawn_position: Vector2
@export var fall_limit: float = 1000.0

var current_attack: bool
@onready var deal_damage = $damage
@onready var hitbox_collision = $damage/CollisionShape2D

func _ready() -> void:
	current_attack = false
	hitbox_collision.disabled = true
	
	sprite.animation_changed.connect(_on_anim_changed)
	sprite.animation_finished.connect(_on_animation_finished)
	
	var spawn = get_tree().current_scene.get_node("SpawnPoint")
	if spawn:
		respawn_position = spawn.global_position
	else:
		respawn_position = global_position

func _physics_process(delta: float) -> void:
	
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
	

	if current_attack:
		pass
	elif not is_on_floor():
		if velocity.y < 0:
			sprite.play("jump")
		else:
			sprite.play("fall")
	else:
		if velocity.x != 0:
			sprite.play("run")
		else:
			sprite.play("idle")
			

	if not is_on_floor():
		if not was_in_air:
			highest_y_point = global_position.y
			was_in_air = true
		else:
			if global_position.y < highest_y_point:
				highest_y_point = global_position.y
	
	if is_on_floor() and was_in_air:
		var fall_distance = global_position.y - highest_y_point
		
		if fall_distance >= high_fall_threshold:
			$landing.play()
		
		was_in_air = false
	
	# footsteps
	if is_on_floor() and velocity.x != 0:
		if not $steps.playing:
			$steps.play()
	else:
		$steps.stop()
		
	if global_position.y > fall_limit:
		take_damage(0.3)
		respawn()
	
	for i in range(get_slide_collision_count()):
		var collision = get_slide_collision(i)
		var collider = collision.get_collider()
		if collider.is_in_group("enemies"):
			take_damage(0.2)

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("options"):
		Global.goto_scene("res://scenes/options.tscn")

func take_damage(amount):
	if $IFrameTimer.is_stopped():
		Global.health -= amount
		$hurt.play()
		$IFrameTimer.start()
		modulate = Color.RED
		await get_tree().create_timer(0.1).timeout
		modulate = Color.WHITE
	
	if Global.health <= 0:
		Global.die()

func respawn():
	global_position = respawn_position
	velocity = Vector2.ZERO

func start_attack():
	current_attack = true
	sprite.play("attack")
	$hit.play()
	hitbox_collision.disabled = false

	await get_tree().create_timer(0.2).timeout # ← shorter time
	end_attack()

func end_attack():
	current_attack = false
	hitbox_collision.set_deferred("disabled", true)

func _on_animation_finished():
	if sprite.animation == "attack":
		end_attack()

func _on_damage_body_entered(body: Node2D) -> void:
	if body.is_in_group("enemies"):
		if body.has_method("take_damage"):
			body.take_damage(1)

func _on_anim_changed():
	match sprite.animation:
		"attack":
			visual.position = Vector2(0, -16)
		"run":
			visual.position = Vector2.ZERO
		"idle":
			visual.position = Vector2.ZERO
