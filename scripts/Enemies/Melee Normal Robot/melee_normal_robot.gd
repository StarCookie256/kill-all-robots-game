extends "res://scripts/Enemies/enemy_base.gd"

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
