extends Node2D

# Настройки волн
@export var waves: Array[Dictionary] = [
    {
        "delay": 2.0,
        "missiles": [
            {"type": "STANDARD", "count": 5},
            {"type": "ZIGZAG", "count": 2}
        ]
    },
    {
        "delay": 3.0,
        "missiles": [
            {"type": "HOMING", "count": 3},
            {"type": "BOMBER", "count": 1}
        ]
    }
]

var current_wave: int = 0
@onready var spawn_timer: Timer = $SpawnTimer

func _ready():
    start_next_wave()

func start_next_wave():
    if current_wave >= waves.size():
        victory()
        return
    
    var wave = waves[current_wave]
    spawn_timer.wait_time = wave["delay"]
    spawn_timer.start()
    
    for missile_data in wave["missiles"]:
        for i in range(missile_data["count"]):
            spawn_missile(missile_data["type"])
    
    current_wave += 1

func spawn_missile(type: String):
    var missile = preload("res://scenes/Missile.tscn").instantiate()
    
    # Установка типа через enum
    match type:
        "STANDARD":
            missile.type = MissileType.STANDARD
        "ZIGZAG":
            missile.type = MissileType.ZIGZAG
        "HOMING":
            missile.type = MissileType.HOMING
        "BOMBER":
            missile.type = MissileType.BOMBER
    
    missile.position = Vector2(
        randf_range(50, get_viewport_rect().size.x - 50),
        -50
    )
    add_child(missile)

func _on_spawn_timer_timeout():
    start_next_wave()

func victory():
    get_tree().change_scene_to_file("res://scenes/VictoryScreen.tscn")
