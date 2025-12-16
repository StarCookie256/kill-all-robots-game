extends "res://scripts/Enemies/enemy_base.gd"

@export var CHARGE_SPEED: float = 500

@onready var detectionAnimTimer = $DetectionAnimTimer
@onready var chargeAnimTimer = $ChargeAnimTimer
@onready var charging: bool = false
@onready var charge_direction: int = 1
@onready var detected: bool = false
@onready var hitBox = $HitBox

func _ready() -> void:
	hp_bar.max_value = MAX_HP
	DMG = 10
	hitBox.monitorable = false
	hitBox.monitoring = false

func _physics_process(delta: float) -> void:
	hp_bar.value = HP
	if stopAll:
		return
	if HP <= 0:
		await _die()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if charging:
		_charged_move()
	else:
		_move()


func _on_vision_body_shape_entered(_body_rid: RID, body: Node2D, _body_shape_index: int, _local_shape_index: int) -> void:
	if !detected && body is Player:
		stopAll = true
		detected = true
		sprite.play("Start Attack")
		
		if player:
			if player.global_position.x > global_position.x:
				charge_direction = 1  # идем вправо
			elif player.global_position.x < global_position.x:
				charge_direction = -1  # идем влево
		
		detectionAnimTimer.start()


func _on_detection_anim_timer_timeout() -> void:
	stopAll = false
	charging = true
	hitBox.monitorable = true
	hitBox.monitoring = true
	chargeAnimTimer.start()


func _charged_move() -> void:
	# Движение
	velocity.x = CHARGE_SPEED * charge_direction
	if charge_direction != 0:
		sprite.play("Attack")
		sprite.flip_h = charge_direction < 0  # переворачиваем спрайт при движении влево
	else:
		sprite.stop()

	move_and_slide()


func _on_charge_anim_timer_timeout() -> void:
	HP = 0
	await _die()


func _on_hit_box_body_entered(body: Node2D) -> void:
	if body is Player:
		HP = 0
		Global._on_hero_taked_damage.emit(DMG)
		await _die()
