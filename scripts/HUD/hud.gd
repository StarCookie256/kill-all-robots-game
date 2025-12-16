extends CanvasLayer

@export var MAX_VALUE: int =  100

@onready var takenDamageAnim = $Control/TakedDamageControl/TakedDamageAnim
@onready var takenDamageLabel = $Control/TakedDamageControl/TakedDamageLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	takenDamageLabel.visible = false
	Global._on_hero_taked_damage.connect(_taked_damage_anim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_hp(new_hp) -> void:
	%HeroHP.value = 100.0/MAX_VALUE * new_hp

func _taked_damage_anim(damage: int) -> void:
	takenDamageLabel.visible = true
	takenDamageLabel.text = "- "+str(damage)
	takenDamageAnim.play("player_damage")
	await takenDamageAnim.animation_finished
	takenDamageLabel.visible = false
