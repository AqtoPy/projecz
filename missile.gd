extends Area2D

enum MissileType {
	STANDARD,  # Летит прямо
	ZIGZAG,    # Меняет направление
	HOMING     # Преследует игрока
}

@export var type: MissileType = MissileType.STANDARD
@export var speed: float = 200
@export var health: int = 50
@export var damage: int = 20
@export var direction_change_time: float = 1.0  # Для ZIGZAG

var direction: Vector2 = Vector2.DOWN
var target: Node2D  # Для HOMING
var time_since_direction_change: float = 0.0

func _ready():
	add_to_group("missiles")
	
	match type:
		MissileType.ZIGZAG:
			direction = Vector2(randf_range(-0.5, 0.5), 1.0).normalized()
		MissileType.HOMING:
			target = get_tree().get_nodes_in_group("player")[0]

func _physics_process(delta):
	time_since_direction_change += delta
	
	match type:
		MissileType.STANDARD:
			position += direction * speed * delta
		
		MissileType.ZIGZAG:
			if time_since_direction_change >= direction_change_time:
				direction = Vector2(randf_range(-0.5, 0.5), 1.0).normalized()
				time_since_direction_change = 0.0
			position += direction * speed * delta
		
		MissileType.HOMING:
			if target:
				direction = (target.global_position - global_position).normalized()
			position += direction * speed * delta
	
	# Удаление при выходе за экран
	if position.y > get_viewport_rect().size.y + 50:
		queue_free()

func take_damage(amount: int):
	health -= amount
	if health <= 0:
		explode()

func explode():
	if is_instance_valid(get_parent().get_node("Gun")):
		get_parent().get_node("Gun").on_missile_destroyed()
	queue_free()

func _on_body_entered(body):
	if body.is_in_group("player"):
		body.take_damage(damage)
		explode()
