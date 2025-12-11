extends CharacterBody2D

const SPEED = 300 # Скорость движения
var direction = 0 # 0 - стоп, 1 - вправо, -1 - влево
const JUMP_VELOCITY = 400

func _physics_process(delta):
	
	velocity.x += SPEED
