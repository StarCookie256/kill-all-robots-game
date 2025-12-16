class_name BulletBase extends Area2D

@export var direction: Vector2
@export var speed: float = 800.0
@export var damage: float = 1.0

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_body_entered(body: Node2D) -> void:
	# код для нанесения урона
	if body is Enemy:
		body._take_damage(damage)
