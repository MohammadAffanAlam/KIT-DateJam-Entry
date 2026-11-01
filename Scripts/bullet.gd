extends RigidBody2D

var speed = 275
var can_bounce = true
@onready var trail: Line2D = $Trail

func _ready() -> void:
	contact_monitor = true
	max_contacts_reported = 1


func fire():
	apply_impulse(Vector2(speed, 0).rotated(rotation), position)
	


func _on_body_entered(body: Node2D) -> void:
	if (body.get_collision_layer_value(2)):
		if (can_bounce):
			can_bounce = false
			trail.queue_free()
		else:
			queue_free()
	else:
		body.damage()
		queue_free()
