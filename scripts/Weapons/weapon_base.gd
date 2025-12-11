class_name WeaponBase extends Node2D

@export var shoot_interval: float = 0.1
@export var bullet: PackedScene
@export var bullet_spawnpoint: Node2D

func shoot():
	var bullet_instance: BulletBase = bullet.instantiate()
	bullet_instance.direction = Vector2.from_angle(global_rotation)
	bullet_instance.global_position = bullet_spawnpoint.global_position
	get_tree().root.get_node("Main/BulletsContainer").add_child(bullet_instance)
