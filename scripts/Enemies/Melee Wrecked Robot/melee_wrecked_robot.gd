extends "res://scripts/Enemies/enemy_base.gd"

@onready var leftAttack = $AnimatedSprite2D/HitLeft
@onready var rightAttack = $AnimatedSprite2D/HitRight

func _physics_process(delta: float) -> void:
	hp_bar.value = HP
	if stopAll:
		return
	if HP <= 0:
		await _die()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if sprite.flip_h:
		rightAttack.monitoring = false
		rightAttack.monitorable = false
		leftAttack.monitoring = true
		leftAttack.monitorable = true
	else:
		rightAttack.monitoring = true
		rightAttack.monitorable = true
		leftAttack.monitoring = false
		leftAttack.monitorable = false
	 
	_move()


func _attack() -> void:
	print("Попался халяль")
	
	while !playerExited && HP > 0:
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
