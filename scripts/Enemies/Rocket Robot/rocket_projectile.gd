extends RigidBody2D

@export var SPEED: float = 400
@export var DMG: float = 10
@export var GRAVITY: float = 980.0  # Гравитация проекта

@onready var sprite = $Sprite2D
@onready var spriteAnimation = $AnimatedSprite2D
@onready var hitArea = $HitArea

var stop_move: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	spriteAnimation.hide()
	# Включаем отслеживание столкновений
	contact_monitor = true
	max_contacts_reported = 1
	hitArea.set_deferred("monitorable", false)
	hitArea.set_deferred("monitoring",false)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta: float) -> void:
	if stop_move:
		return
	if linear_velocity.length() > 0.1:
		var target_angle = linear_velocity.angle()
		rotation = lerp_angle(rotation, target_angle, 10.0*delta)


func shoot(player_pos: Vector2) -> void:
	var arc_height: float = _calculate_arc_height_for_target(global_position, player_pos, SPEED)
	var vertical_force = Vector2(0, -arc_height)
	
	var direction: Vector2 = (player_pos - global_position).normalized()
	apply_impulse((direction * SPEED)+vertical_force)

func _calculate_arc_height_for_target(start_pos: Vector2, target_pos: Vector2, speed: float) -> float:
	var g = ProjectSettings.get_setting("physics/2d/default_gravity")  # Обычно 980
	var dx = target_pos.x - start_pos.x
	var dy = target_pos.y - start_pos.y
	
	if abs(dx) < 0.1:  # Почти вертикальный выстрел
		return abs(dy) * 2.0
	
	var angle = deg_to_rad(45)
	var cos_angle = cos(angle)
	var cos_squared = cos_angle * cos_angle
	
	var denominator = 2 * cos_squared * (dx - dy)
	
	if denominator <= 0:
		# Невозможно попасть под 45°, увеличиваем угол
		return abs(dx) * 1.2 + abs(dy) * 1.5
	
	# 3. Вычисляем необходимую скорость
	var needed_speed_squared = (g * dx * dx) / denominator
	var needed_speed = sqrt(abs(needed_speed_squared))
	# 4. Если наша скорость меньше необходимой, нужно увеличить высоту дуги
	var speed_ratio = needed_speed / speed
	# 5. Высота параболы: H = (v² * sin²θ) / (2g)
	var base_height = (speed * speed * sin(angle) * sin(angle)) / (2 * g)
	
	var corrected_height = base_height * speed_ratio * 1.5
	
	# 7. Учитываем разницу высот
	if dy < 0:  # Цель ВЫШЕ
		corrected_height += abs(dy) * 1.2
	else:  # Цель НИЖЕ
		corrected_height += dy * 0.6  # Все равно добавляем, но меньше
	
	# 8. Учитываем горизонтальное расстояние
	corrected_height += abs(dx) * 1.1
	
	# 9. Ограничиваем разумными значениями
	return clamp(corrected_height, 100.0, 1500.0)


func _on_body_entered(_body: Node) -> void:
	stop_move = true
	linear_velocity = Vector2.ZERO
	angular_velocity = 0
	
	await get_tree().create_timer(0.05).timeout
	hitArea.set_deferred("monitorable", true)
	hitArea.set_deferred("monitoring",true)
	
	sprite.hide()
	spriteAnimation.show()
	spriteAnimation.play("Explode")
	
	print('БУУУУУУУУУУУУУУУУУМ *щелчок демона-бомбы')
	await spriteAnimation.animation_finished
	
	queue_free()


func _on_hit_area_body_entered(body: Node2D) -> void:
	if body is Player:
		Global._on_hero_taked_damage.emit(DMG)
		hitArea.set_deferred("monitorable", false)
		hitArea.set_deferred("monitoring",false)
