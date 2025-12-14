extends CharacterBody2D

@export var SPEED: float = 120
@export var HP: float = 100
@export var DEF: float = 0
@export var DMG: float = 5

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
