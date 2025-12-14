extends RigidBody2D

@export var SPEED: float = 400
@export var DMG: float = 10
@onready var initial_velocity: Vector2

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if initial_velocity != Vector2.ZERO:
		apply_central_impulse(initial_velocity*SPEED)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_body_entered(_body: Node) -> void:
	print('БУУУУУУУУУУУУУУУУУМ *щелчок демона-бомбы')
	queue_free()
