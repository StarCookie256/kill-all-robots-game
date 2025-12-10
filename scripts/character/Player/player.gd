extends CharacterBody2D

const SPEED = 300 # Скорость движения
var direction = 0 # 0 - стоп, 1 - вправо, -1 - влево
const JUMP_VELOCITY = 400

func _physics_process(delta):
	# Получаем ввод
	direction = 0 # Сбрасываем направление в начале кадра
	if Input.is_action_pressed("move_right"): # Предполагается, что "move_right" привязана к D или стрелке вправо
		direction += 1
		$Node2D/HandLeft.visible = false
		$Node2D/HandRight.visible = true
	if Input.is_action_pressed("move_left"): # Предполагается, что "move_left" привязана к A или стрелке влево
		direction -= 1
		$Node2D/HandLeft.visible = true
		$Node2D/HandRight.visible = false
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Handle jump.
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y -= JUMP_VELOCITY

	# Применяем движение
	velocity.x = direction * SPEED
	move_and_slide()
	if direction == 1:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.flip_h = false
	elif direction == -1:
		$AnimatedSprite2D.play("Walk")
		$AnimatedSprite2D.flip_h = true
	else:
		$AnimatedSprite2D.play("Idle")
