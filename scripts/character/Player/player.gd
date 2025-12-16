class_name Player extends CharacterBody2D

const SPEED = 300
const JUMP_VELOCITY = 400

@export var HP = 100
@export var HUD: CanvasLayer

@onready var sprite := $AnimatedSprite2D
@onready var left_hand: Node2D = $NodeLeft
@onready var right_hand: Node2D = $NodeRight
@onready var camera: = $Camera2D

var direction := 0
var facing_left := false
var current_hand: Node2D  # ← Тип Node2D, не WeaponBase

func _ready() -> void:
	current_hand = right_hand
	Global._on_hero_taked_damage.connect(_on_damage_received)

func _physics_process(delta: float) -> void:
	HUD.set_hp(HP)
	direction = Input.get_axis("move_left", "move_right")
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if Input.is_action_just_pressed("move_jump") and is_on_floor():
		velocity.y = -JUMP_VELOCITY
	
	velocity.x = direction * SPEED
	move_and_slide()
	
	_update_aim()
	_update_animations()

func _update_aim() -> void:
	var mouse_pos := get_global_mouse_position()
	facing_left = mouse_pos.x < global_position.x
	
	sprite.flip_h = facing_left
	
	if facing_left:
		current_hand = left_hand
		left_hand.visible = true
		right_hand.visible = false
	else:
		current_hand = right_hand
		left_hand.visible = false
		right_hand.visible = true
	
	var direction_to_mouse := mouse_pos - current_hand.global_position
	var angle := direction_to_mouse.angle()
	
	if facing_left:
		current_hand.rotation = angle + PI / 2
		current_hand.scale.y = -1
	else:
		current_hand.rotation = angle - PI / 2
		current_hand.scale.y = 1

func _update_animations() -> void:
	if not is_on_floor():
		sprite.play("Jump")
	elif direction != 0:
		sprite.play("Walk")
	else:
		sprite.play("Idle")

func _input(event: InputEvent) -> void:
	if event.is_action_pressed("shoot"):
		# Получаем оружие из текущей руки
		var gun := current_hand.get_node("Weapon/Pistol") as WeaponBase
		if gun:
			gun.shoot()


func _on_damage_received(damage: int) -> void:
	HP -= damage
