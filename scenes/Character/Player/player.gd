extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = 400
var direction = 0

@export var gun: WeaponBase
@onready var sprite := $AnimatedSprite2D

func _physics_process(delta):
	_update_hand_and_direction()
	
	direction = Input.get_axis("move_left", "move_right")
	
	# Гравитация
	if not is_on_floor():
		velocity += get_gravity() * delta

	# Прыжок
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	velocity.x = direction * SPEED

	move_and_slide()

	# Анимации
	if not is_on_floor():
		if velocity.y < 0:
			sprite.play("Jump")  # подъем
		else:
			sprite.frame = 2
			sprite.play("Jump")  # падение, та же анимация зациклена
	elif direction != 0:
		sprite.play("Walk")
		sprite.flip_h = direction < 0
	else:
		sprite.play("Idle")


func _update_hand_and_direction():
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position
	var mouse_is_left = mouse_pos.x < player_pos.x
	sprite.flip_h = mouse_is_left

	if mouse_is_left:
		$NodeLeft.visible = true
		$NodeRight.visible = false
		var direction_vector = mouse_pos - $NodeLeft.global_position
		$NodeLeft.rotation = direction_vector.angle() + PI + 90
	else:
		$NodeLeft.visible = false
		$NodeRight.visible = true
		var direction_vector = mouse_pos - $NodeRight.global_position
		$NodeRight.rotation = direction_vector.angle() - 90

	# Поворот пистолета
	var gun_rotation = (get_local_mouse_position() - $GunContainer.position).angle()
	$GunContainer.rotation = gun_rotation - PI / 2

@onready var shoot_timer := Timer.new()
var shots_left := 0

func _ready():
	# Настраиваем таймер
	shoot_timer.wait_time = 0.01  # время между выстрелами (в секундах)
	shoot_timer.one_shot = false
	add_child(shoot_timer)
	shoot_timer.connect("timeout", Callable(self, "_on_timer_timeout"))

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		shots_left = 10000  # количество выстрелов
		shoot_timer.start()

func _on_timer_timeout():
	if shots_left > 0:
		gun.shoot()
		shots_left -= 1
		print("Time to attack! Shots left:", shots_left)
	else:
		shoot_timer.stop()
			
