extends Area2D

# Настройки
@export var bullet_scene: PackedScene = preload("res://scenes/Bullet.tscn")
@export var max_health: int = 100
@export var missiles_to_defeat: int = 10  # Цель для победы

var current_health: int
var missiles_defeated: int = 0
var can_shoot: bool = true

@onready var health_label: Label = $HealthLabel
@onready var missile_counter: Label = $MissileCounter
@onready var shoot_timer: Timer = $ShootTimer

func _ready():
	current_health = max_health
	update_ui()

func _input(event):
	if event is InputEventMouseButton and event.pressed and can_shoot:
		shoot()
		can_shoot = false
		shoot_timer.start(0.3)  # Задержка между выстрелами

func shoot():
	var bullet = bullet_scene.instantiate()
	bullet.position = global_position
	bullet.direction = (get_global_mouse_position() - global_position).normalized()
	get_parent().add_child(bullet)

func take_damage(damage: int):
	current_health -= damage
	update_ui()
	if current_health <= 0:
		game_over()

func on_missile_destroyed():
	missiles_defeated += 1
	update_ui()
	if missiles_defeated >= missiles_to_defeat:
		victory()

func update_ui():
	health_label.text = "HP: %d" % current_health
	missile_counter.text = "Ракет: %d/%d" % [missiles_defeated, missiles_to_defeat]

func game_over():
	var game_over_screen = preload("res://scenes/ui/GameOverScreen.tscn").instantiate()
	get_tree().root.add_child(game_over_screen)
	get_tree().paused = true

func victory():
	var victory_screen = preload("res://scenes/ui/VictoryScreen.tscn").instantiate()
	victory_screen.current_level = get_tree().current_scene.name
	get_tree().root.add_child(victory_screen)
	get_tree().paused = true

func _on_shoot_timer_timeout():
	can_shoot = true
