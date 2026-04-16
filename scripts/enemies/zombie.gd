extends CharacterBody2D

@export var speed = 100.0
@export var patrol_points_path: NodePath
var knockback_velocity = Vector2.ZERO
var is_knocked_back = false

var points = []
var current_point_index = 0
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

@onready var floor_ray = $FloorRay
@onready var sprite = $AnimatedSprite2D

@export var health = 2.0
var is_dead = false

func _ready():
	var container = get_node(patrol_points_path)
	for child in container.get_children():
		points.append(child.global_position)

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

func take_damage(amount):
	if is_dead:
		return
	
	$hurt.play()
	health -= amount
	modulate = Color.RED
	await get_tree().create_timer(0.1).timeout
	modulate = Color.WHITE
	
	if health <= 0:
		die()

func die():
	is_dead = true
	queue_free()
