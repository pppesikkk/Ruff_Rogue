extends Area2D

var direction = Vector2.ZERO
@export var speed: float = 360.0

@onready var anim = $AnimatedSprite2D

func _ready():
	# Play the flying animation as soon as it spawns
	anim.play("default")



func _process(delta):
	if direction != Vector2.ZERO:
		global_position += direction * speed * delta

# This is the "setter" function the enemy will call
func set_direction(new_direction: Vector2):
	direction = new_direction
	rotation = direction.angle()

func _on_body_entered(body):
	if body.is_in_group("enemies"):
		return
		
	# Deal damage
	if body.has_method("take_damage"):
		body.take_damage(0.7)
	explode()

func explode():
	set_process(false) 
	direction = Vector2.ZERO
	$CollisionShape2D.set_deferred("disabled", true)
	queue_free()

func _on_visible_on_screen_notifier_2d_screen_exited():
	# Clean up memory if it misses everything
	queue_free()
