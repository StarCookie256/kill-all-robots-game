class_name BulletBase extends Area2D

@export var direction: Vector2
@export var speed: float = 200.0
@export var damage: float = 1.0

func _process(delta: float) -> void:
	global_position += direction * speed * delta

func _on_area_entered(area: Area2D) -> void:
	# код для нанесения урона
	pass # Replace with function body.
