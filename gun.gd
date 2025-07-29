extends Area2D

# Настройки
@export var bullet_scene: PackedScene = preload("res://scenes/Bullet.tscn")
@export var max_health: int = 100
@export var max_missiles_missed: int = 5     # Макс пропущенных ракет
@export var fire_rate: float = 0.2           # Задержка между выстрелами
@export var rotation_speed: float = 5.0      # Скорость поворота

# Состояние
var current_health: int
var missiles_missed: int = 0
var missiles_destroyed: int = 0
var can_shoot: bool = true
var target_direction: Vector2 = Vector2.UP

@onready var sprite: Sprite2D = $Sprite2D
@onready var shoot_timer: Timer = $ShootTimer
@onready var health_label: Label = $UI/HealthLabel
@onready var missiles_label: Label = $UI/MissilesLabel

func _ready():
    current_health = max_health
    update_ui()
    add_to_group("player")  # Для homing-ракет
    shoot_timer.wait_time = fire_rate

func _process(delta):
    # Поворот пушки к курсору
    var mouse_pos = get_global_mouse_position()
    target_direction = (mouse_pos - global_position).normalized()
    sprite.rotation = lerp_angle(sprite.rotation, target_direction.angle(), rotation_speed * delta)

func _input(event):
    if event.is_action_pressed("shoot") and can_shoot:
        shoot()
        can_shoot = false
        shoot_timer.start()

func shoot():
    var bullet = bullet_scene.instantiate()
    bullet.position = global_position
    bullet.direction = target_direction  # Пуля летит куда направлена пушка
    get_parent().add_child(bullet)

func take_damage(amount: int):
    current_health -= amount
    update_ui()
    if current_health <= 0:
        game_over()

func on_missile_destroyed():
    missiles_destroyed += 1
    update_ui()

func on_missile_missed():
    missiles_missed += 1
    update_ui()
    if missiles_missed >= max_missiles_missed:
        game_over()

func update_ui():
    health_label.text = "HP: %d/%d" % [current_health, max_health]
    missiles_label.text = "Пропущено: %d/%d | Уничтожено: %d" % [missiles_missed, max_missiles_missed, missiles_destroyed]

func game_over():
    get_tree().change_scene_to_file("res://scenes/GameOverScreen.tscn")

func _on_shoot_timer_timeout():
    can_shoot = true
