extends CharacterBody2D

var player_actions = {
	pos = [],
	rotation = []
}
var bullet_path = preload("res://Scenes/bullet.tscn")
const MAX_HEALTH = 3
var health = 3
var speed = 150
@onready var shooting_timer: Timer = $ShootingTimer
@onready var invulnerability_timer: Timer = $InvulnerabilityTimer
@onready var bullet_location: Node2D = $BulletLocation
@onready var spawn_radius: Area2D = $SpawnRadius
@onready var bullet_manager: Node = %BulletManager
@onready var invulnerability_animation: AnimationPlayer = $InvulnerabilityAnimation
@onready var game_manager: Node = %GameManager

func _ready() -> void:
	reset_player()
	set_physics_process(true)
	
func reset_player():
	
	var rng = RandomNumberGenerator.new()
	
	position = Vector2(rng.randf_range(-125, 125), rng.randf_range(-125, 125))
	health = MAX_HEALTH
	
	while (!spawn_radius.get_overlapping_bodies().is_empty()):
		position = Vector2(rng.randf_range(-210, 210), rng.randf_range(-95, 115))
	
	player_actions.pos.clear()
	player_actions.rotation.clear()
	spawn_radius.get_overlapping_bodies()
	set_physics_process(false)

func _process(delta: float) -> void:
	look_at(get_global_mouse_position())

func _physics_process(delta: float) -> void:
	var input_direction = Input.get_vector("left", "right", "up", "down")
	velocity = input_direction * speed
	move_and_slide()
	player_actions.pos.append(position)
	player_actions.rotation.append(rotation)

func damage():
	if (invulnerability_timer.is_stopped()):
		health -= 1
		invulnerability_timer.start()
		invulnerability_animation.play("Invulnerable")
		if (health <= 0):
			get_tree().call_deferred("change_scene_to_file", "res://Scenes/game_over.tscn")
			#get_tree().change_scene_to_file("res://Scenes/game_over.tscn")
		else:
			game_manager.update_health_UI(health)



func _on_shooting_timer_timeout() -> void:
	var bullet = bullet_path.instantiate()
	bullet.position = bullet_location.global_position
	bullet.rotation = rotation
	bullet_manager.add_child(bullet)
	bullet.fire()
	
