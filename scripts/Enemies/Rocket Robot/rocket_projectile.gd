extends RigidBody2D

@export var SPEED: float = 400
@export var DMG: float = 10
@export var GRAVITY: float = 980.0  # Гравитация проекта

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# Включаем отслеживание столкновений
	contact_monitor = true
	max_contacts_reported = 1


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func shoot(player_pos: Vector2) -> void:
	var arc_height: float = calculate_arc_height_for_target(global_position, player_pos, SPEED)
	var vertical_force = Vector2(0, -arc_height)
	
	
	var direction: Vector2 = (player_pos - global_position).normalized()
	apply_impulse((direction * SPEED)+vertical_force)

func calculate_arc_height_for_target(start_pos: Vector2, target_pos: Vector2, _speed: float) -> float:
	#var height = (target_pos - start_pos).normalized()
	var height: float = 42.0
	return height


func _on_body_entered(_body: Node) -> void:
	print('БУУУУУУУУУУУУУУУУУМ *щелчок демона-бомбы')
	queue_free()
