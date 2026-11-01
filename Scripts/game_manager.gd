extends Node

@onready var player: CharacterBody2D = %Player
@onready var enemy_manager: Node = $EnemyManager
@onready var bullet_manager: Node = %BulletManager
@onready var wave_start_countdown: Timer = $WaveStartCountdown
@onready var wave_starting_tint: CanvasModulate = $WaveStartingTint
@onready var ui_animation: AnimationPlayer = %UIAnimation
@onready var wave_label: Label = $"../UI/WaveLabel"


var enemy_path = preload("res://Scenes/enemy.tscn")
var waveNum = 0
var amountOfEnemies = 1

func start_new_wave():
	for bullet in bullet_manager.get_children(true):
		bullet.queue_free()
		
	var new_enemy = enemy_path.instantiate()
	enemy_manager.call_deferred("add_child", new_enemy)
	new_enemy.actions.pos = player.player_actions.pos.duplicate()
	new_enemy.actions.rotation = player.player_actions.rotation.duplicate()
	
	for enemy in enemy_manager.get_children():
		enemy.set_starting_state()
	
	player.reset_player()
	waveNum += 1
	amountOfEnemies = waveNum
	wave_start_countdown.start()
	get_tree().paused = true
	ui_animation.play("New Wave Countdown")
	wave_starting_tint.show()
	wave_label.text = "Wave " + str(waveNum)

func enemy_died():
	amountOfEnemies -= 1
	if (amountOfEnemies <= 0):
		start_new_wave()

func update_health_UI(health: int):
	if (health == 2):
		ui_animation.play("2 Lives")
	else:
		ui_animation.play("1 Life")

func _on_wave_start_countdown_timeout() -> void:
	for enemy in enemy_manager.get_children(true):
		enemy.set_physics_process(true)
	player.set_physics_process(true)
	wave_starting_tint.hide()
	get_tree().paused = false
