extends Node2D

@export var missile_scenes: Array[PackedScene] = [
	preload("res://scenes/missiles/StandardMissile.tscn"),
	preload("res://scenes/missiles/ZigZagMissile.tscn")
]
@export var missile_count: int = 10
@export var spawn_interval: float = 2.0

var missiles_spawned: int = 0
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
	spawn_timer.wait_time = spawn_interval
	spawn_timer.start()

func _on_spawn_timer_timeout():
	if missiles_spawned >= missile_count:
		spawn_timer.stop()
		return
	
	var missile: Area2D
	
	# Выбираем случайный тип ракеты
	if randf() < 0.7:  # 70% шанс обычной ракеты
		missile = missile_scenes[0].instantiate()
	else:
		missile = missile_scenes[1].instantiate()
	
	# Случайная позиция сверху экрана
	missile.position = Vector2(randf_range(50, get_viewport_rect().size.x - 50), -20)
	add_child(missile)
	missiles_spawned += 1
