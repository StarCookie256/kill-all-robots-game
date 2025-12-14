extends "res://scripts/Enemies/enemy_base.gd"

@onready var shotMarker: = $AnimatedSprite2D/ShotMarkerRight
@onready var rocket_scene = preload("res://scenes/Enemies/Rocket Robot/rocket_projectile.tscn")
@onready var attackStartTimer = $AttackStartTimer

func _attack() -> void:
	shotMarker = $AnimatedSprite2D/ShotMarkerLeft if sprite.flip_h else $AnimatedSprite2D/ShotMarkerRight
	while !playerExited:
		sprite.play("Attack")
		
		# ждем когда робот подымет пушку для выпуска снаряда
		attackStartTimer.start() 
		await attackStartTimer.timeout
		
		var pos:Vector2 = player.global_position
		var direction:Vector2 = (pos - global_position).normalized()
		var rocket = rocket_scene.instantiate()
		get_parent().add_child(rocket)
		
		rocket.global_position = shotMarker.global_position
		rocket.initial_velocity = direction
		
		await sprite.animation_finished
		sprite.stop()


func _on_visible_on_screen_notifier_2d_screen_entered() -> void:
	print('щас тя бомбить буим')
	playerExited = false # игрок еще находится в зоне атаки
	stopAll = true
	
	await _attack()
	stopAll = false


func _on_visible_on_screen_notifier_2d_screen_exited() -> void:
	playerExited = true
