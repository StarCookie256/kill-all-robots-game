extends CanvasLayer

@export var MAX_VALUE: int =  100

@onready var playerTakedDamageScene = preload("res://scenes/HUD/player_taked_damage.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	Global._on_hero_taked_damage.connect(_taked_damage_anim)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass

func set_hp(new_hp) -> void:
	%HeroHP.value = 100.0/MAX_VALUE * new_hp

func _taked_damage_anim(damage: int) -> void:
	var newLabel = playerTakedDamageScene.instantiate()
	add_child(newLabel)
	newLabel.get_node("TakedDamageControl/TakedDamageLabel").text = "- "+str(damage)
	newLabel.get_node("TakedDamageControl/TakedDamageAnim").play("player_damage")
	await newLabel.get_node("TakedDamageControl/TakedDamageAnim").animation_finished
	newLabel.queue_free()
