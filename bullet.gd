extends Area2D

# Настройки
@export var speed: float = 800          # Скорость пули
@export var damage: int = 25            # Урон по ракетам
@export var max_distance: float = 1200  # Макс. дистанция перед исчезновением

var direction: Vector2 = Vector2.UP     # Направление (задается пушкой)
var distance_traveled: float = 0        # Пройденная дистанция

func _ready():
    # Поворачиваем спрайт по направлению движения
    rotation = direction.angle() + PI/2

func _physics_process(delta):
    var movement = direction * speed * delta
    position += movement
    distance_traveled += movement.length()
    
    # Удаление при выходе за пределы дистанции
    if distance_traveled >= max_distance:
        queue_free()

func _on_body_entered(body):
    if body.is_in_group("missiles"):
        body.take_damage(damage)
        queue_free()  # Уничтожаем пулю при попадании
