extends CharacterBody2D

@export var speed = 105.0
@export var bullet_scene: PackedScene
@export var movement_range = 150.0

var target_position = Vector2.ZERO
var player = null

func _ready():
	$AnimatedSprite2D.play("transform")
	player = get_tree().get_first_node_in_group("player")
	update_target_position()
	$MoveTimer.wait_time = randf_range(1.0, 3.0)
	$ShootTimer.wait_time = 1.5 # Fire every 1.5 seconds

func _physics_process(delta):
	var direction = (target_position - global_position).normalized()
	
	if global_position.distance_to(target_position) > 10:
		velocity = velocity.lerp(direction * speed, delta * 2)
	else:
		velocity = velocity.lerp(Vector2.ZERO, delta * 3)
		
	move_and_slide()

func _on_move_timer_timeout():
	update_target_position()
	$MoveTimer.wait_time = randf_range(1.0, 3.0) # Vary the movement timing

func _on_shoot_timer_timeout():
	if player:
		shoot()

func shoot():
	if player == null: return
	var b = bullet_scene.instantiate()
	get_tree().current_scene.add_child(b)
	b.global_position = global_position 
	var dir_to_player = (player.global_position - global_position).normalized()
	b.set_direction(dir_to_player)


@export var flight_zone_center: Vector2 = Vector2(500, 500)
@export var flight_zone_size: Vector2 = Vector2(400, 400)

func update_target_position():
	var random_offset = Vector2(randf_range(-1, 1), randf_range(-1, 1)).normalized() * movement_range
	var potential_target = global_position + random_offset
	
	var min_x = flight_zone_center.x - (flight_zone_size.x / 2)
	var max_x = flight_zone_center.x + (flight_zone_size.x / 2)
	var min_y = flight_zone_center.y - (flight_zone_size.y / 2)
	var max_y = flight_zone_center.y + (flight_zone_size.y / 2)
	
	target_position.x = clamp(potential_target.x, min_x, max_x)
	target_position.y = clamp(potential_target.y, min_y, max_y)
