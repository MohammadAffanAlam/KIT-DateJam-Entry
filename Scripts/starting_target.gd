extends RigidBody2D

var currentVelocity
var health = 3
var speed = 100
@onready var game_manager: Node = %GameManager

func _ready() -> void:
	var rng = RandomNumberGenerator.new()
	apply_impulse(Vector2(speed, 0).rotated(rng.randf_range(0, 2 * PI)), position)

func damage():
	health -= 1
	if (health <= 0):
		game_manager.enemy_died()
		queue_free()

func _physics_process(delta: float) -> void:
	currentVelocity = linear_velocity

func _on_body_entered(body: Node) -> void:
	linear_velocity = currentVelocity
	pass # Replace with function body.
