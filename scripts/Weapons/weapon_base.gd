class_name WeaponBase extends Node2D

@export var shoot_interval: float = 0.1
@export var bullet: PackedScene
@export var bullet_spawnpoint: Node2D

func shoot(direction: Vector2):
	var bullet_instance: BulletBase = bullet.instantiate()
	bullet_instance.direction = direction
	bullet_instance.position = bullet_spawnpoint.position
	bullet_spawnpoint.add_child(bullet_instance)
