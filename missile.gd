extends Area2D

enum MissileType {
    STANDARD,    # Летит прямо вниз
    ZIGZAG,      # Зигзагообразный полет
    HOMING,      # Преследует пушку
    BOMBER       # Летит медленно, но наносит много урона
}

# Настройки
@export var type: MissileType = MissileType.STANDARD
@export var speed: float = 200
@export var health: int = 50
@export var damage: int = 30
@export var zigzag_frequency: float = 2.0   # Для ZIGZAG-типа
@export var homing_power: float = 0.1       # Сила наведения (0-1)

# Внутренние переменные
var direction: Vector2 = Vector2.DOWN
var target: Node2D
var time: float = 0
var initial_x: float

func _ready():
    add_to_group("missiles")
    initial_x = position.x
    target = get_tree().get_nodes_in_group("player")[0]  # Пушка
    
    # Настройки для разных типов
    match type:
        MissileType.BOMBER:
            speed *= 0.6
            damage *= 2
        MissileType.HOMING:
            speed *= 1.2

func _physics_process(delta):
    time += delta
    
    # Логика движения для каждого типа
    match type:
        MissileType.STANDARD:
            position += direction * speed * delta
            
        MissileType.ZIGZAG:
            var zigzag_offset = sin(time * zigzag_frequency) * 100
            position.x = initial_x + zigzag_offset
            position += direction * speed * delta
            
        MissileType.HOMING:
            if target:
                var target_dir = (target.global_position - global_position).normalized()
                direction = direction.lerp(target_dir, homing_power).normalized()
            position += direction * speed * delta
            
        MissileType.BOMBER:
            position += direction * speed * delta
            speed += delta * 20  # Постепенное ускорение
    
    # Поворот спрайта по направлению (кроме BOMBER)
    if type != MissileType.BOMBER:
        rotation = direction.angle() + PI/2
    
    # Удаление при выходе за экран
    if position.y > get_viewport_rect().size.y + 100:
        notify_missed()
        queue_free()

func take_damage(amount: int):
    health -= amount
    if health <= 0:
        notify_destroyed()
        queue_free()

func notify_destroyed():
    if get_tree().get_nodes_in_group("player").size() > 0:
        get_tree().get_nodes_in_group("player")[0].on_missile_destroyed()

func notify_missed():
    if get_tree().get_nodes_in_group("player").size() > 0:
        get_tree().get_nodes_in_group("player")[0].on_missile_missed()

func _on_body_entered(body):
    if body.is_in_group("player"):
        body.take_damage(damage)
        queue_free()
