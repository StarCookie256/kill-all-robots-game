extends Node2D

@onready var animated_sprite = $"../AnimatedSprite2D"
@onready var player = get_parent()
@onready var node_right = $"../NodeRight"
@onready var node_left = $"../NodeLeft"

var was_flipped = false

func _physics_process(delta: float) -> void:
	var mouse_pos = get_global_mouse_position()
	var player_pos = player.global_position
	
	# Определяем, в какую сторону смотрит мышь
	var is_mouse_left = mouse_pos.x < player_pos.x
	
	# Если направление изменилось, меняем сторону
	if is_mouse_left != was_flipped:
		was_flipped = is_mouse_left
		animated_sprite.flip_h = is_mouse_left
	
	# Устанавливаем позицию руки в зависимости от стороны
	if is_mouse_left:
		global_position = node_left.global_position
	else:
		global_position = node_right.global_position
	
	# Поворачиваем руку к мыши
	var direction = mouse_pos - global_position
	rotation = direction.angle()
