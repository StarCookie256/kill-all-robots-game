class_name WeaponBase extends Node2D

@export var shoot_interval: float = 0.01
@export var bullet: PackedScene
@export var bullet_spawnpoint: Node2D

func shoot():
	var bullet_instance: BulletBase = bullet.instantiate()
	
	bullet_instance.global_position = bullet_spawnpoint.global_position
	bullet_instance.direction = (bullet_spawnpoint.global_position
		- global_position).normalized()

	get_tree().current_scene.get_node("BulletsContainer").add_child(bullet_instance)
