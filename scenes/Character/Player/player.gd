extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = 400
var direction = 0

@export var gun: WeaponBase

func _physics_process(delta):
	_update_hand_and_direction()
	
	direction = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta

	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y -= JUMP_VELOCITY
	


	velocity.x = direction * SPEED
	move_and_slide()
	if direction != 0:
		$AnimatedSprite2D.play("Walk")
	else:
		$AnimatedSprite2D.play("Idle")

func _update_hand_and_direction():
	var mouse_pos = get_global_mouse_position()
	var player_pos = global_position
	var mouse_is_left = mouse_pos.x < player_pos.x
	$AnimatedSprite2D.flip_h = mouse_is_left
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
	
	# Кручение верчение пистолета
	var gun_rotation = (get_local_mouse_position() - $GunContainer.position).angle()
	$GunContainer.rotation = gun_rotation  - PI / 2
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		gun.shoot()
