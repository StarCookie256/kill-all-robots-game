extends CharacterBody2D

const SPEED := 120

@onready var sprite := $AnimatedSprite2D
@onready var player := $"../Player"  # Путь к игроку в сцене

func _physics_process(delta):
	# Гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Определяем направление к игроку
	var direction = 0
	if player:
		if player.global_position.x > global_position.x:
			direction = 1  # идем вправо
		elif player.global_position.x < global_position.x:
			direction = -1  # идем влево

	# Движение
	velocity.x = SPEED * direction
	if direction != 0:
		sprite.play("Walk")
		sprite.flip_h = direction < 0  # переворачиваем спрайт при движении влево
	else:
		sprite.stop()

	move_and_slide()
