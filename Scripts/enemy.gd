extends Node2D

var actions = {
	pos = [],
	rotation = []
}
var MAX_HEALTH = 3
var bullet_path = preload("res://Scenes/enemy_bullet.tscn")
var frame = 0
var health = MAX_HEALTH
var speed = 400
var reverse_actions = false
@onready var shooting_timer: Timer = $ShootingTimer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var bullet_location: Node2D = $BulletLocation
@onready var collision_shape: CollisionShape2D = $CollisionShape2D
@onready var death_sound: AudioStreamPlayer2D = $DeathSound

func _ready() -> void:
	set_starting_state()

func set_starting_state():
	health = MAX_HEALTH
	frame = 0
	collision_shape.set_deferred("disabled", false)
	set_physics_process(false)
	show()
	shooting_timer.start()
	if (actions.pos.size() != 0):
		position = actions.pos[0]
		rotation = actions.rotation[0]
		
		
func _physics_process(delta: float) -> void:
	if (!reverse_actions && frame < actions.pos.size()):
		position = actions.pos[frame]
		rotation = actions.rotation[frame]
		frame += 1
	elif (reverse_actions && frame > 0):
		frame -= 1
		position = actions.pos[frame]
		rotation = actions.rotation[frame]
	else:
		reverse_actions = !reverse_actions
		

func damage():
	health -= 1
	if (health <= 0):
		collision_shape.set_deferred("disabled", true)
		set_physics_process(false)
		hide()
		shooting_timer.stop()
		death_sound.play()
		get_parent().get_parent().enemy_died()
		


func _on_shooting_timer_timeout() -> void:
	var bullet = bullet_path.instantiate()
	bullet.position = bullet_location.global_position
	bullet.rotation = rotation
	get_parent().get_parent().get_child(1).add_child(bullet)
	bullet.fire()
	
