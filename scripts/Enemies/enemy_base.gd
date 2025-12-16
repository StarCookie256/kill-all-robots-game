class_name Enemy extends CharacterBody2D

@export var SPEED: float = 120
@export var HP: float = 10
@export var MAX_HP: float = 10
@export var DEF: float = 0
@export var DMG: float = 5

@onready var sprite := $AnimatedSprite2D
@onready var player := $"../Player" 
@onready var stopAll := false
@onready var playerExited := true
@onready var hp_bar = $TextureProgressBar

func _ready() -> void:
	hp_bar.max_value = MAX_HP

func _physics_process(delta: float) -> void:
	hp_bar.value = HP
	if stopAll:
		return
	if HP <= 0:
		await _die()
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	_move()

func _move() -> void:
# Определяем направление к игроку
	var direction = 0
	if player:
		if player.global_position.x > global_position.x+5:
			direction = 1  # идем вправо
		elif player.global_position.x < global_position.x-5:
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
	Global._on_hero_taked_damage.emit(DMG)


func _take_damage(damage: float) -> void:
	print('АААААААААААААААААААААААААААААААААААЙ')
	HP -= damage


func _die() -> void:
	stopAll = true
	sprite.play("Death")
	await sprite.animation_finished
	sprite.stop()
	queue_free()
