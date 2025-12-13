extends CharacterBody2D

const SPEED :float = 120
const HP :float = 100

@onready var sprite := $AnimatedSprite2D
@onready var player := $"../Player" 
@onready var stopAll := false
@onready var playerExited := true

func _ready() -> void:
	pass # Replace with function body.

func _physics_process(delta: float) -> void:
	if stopAll:
		return
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_move()

func _move() -> void:
# Определяем направление к игроку
	var direction = 0
	if player:
		if player.global_position.x > global_position.x+10:
			direction = 1  # идем вправо
		elif player.global_position.x < global_position.x-10  :
			direction = -1  # идем влево

	# Движение
	velocity.x = SPEED * direction
	if direction != 0:
		sprite.play("Walk")
		sprite.flip_h = direction < 0  # переворачиваем спрайт при движении влево
	else:
		sprite.stop()

	move_and_slide()

func _attack() -> void:
	print("Попался халяль")
	
	while !playerExited:
		sprite.play("Attack")
		await sprite.animation_finished
		sprite.stop()

func _on_hit_body_shape_entered(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if _body is Player:
		playerExited = false # игрок еще находится в зоне атаки
		stopAll = true
		
		await _attack()
		
		stopAll = false

func _on_hit_body_shape_exited(_body_rid: RID, _body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	playerExited = true # игрок вышел из зоны
