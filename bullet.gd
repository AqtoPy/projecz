extends Area2D

# Настройки
var speed = 500
var direction = Vector2.UP  # Летит вверх по умолчанию
var damage = 25

func _ready():
	# Автоматически удаляется, если вылетает за экран
	set_physics_process(true)

func _physics_process(delta):
	position += direction * speed * delta

	# Удаление при выходе за границы экрана
	if position.y < -50 or position.y > get_viewport_rect().size.y + 50:
		queue_free()

func _on_body_entered(body):
	if body.is_in_group("missiles"):  # Если попала в ракету
		body.take_damage(damage)
		queue_free()
