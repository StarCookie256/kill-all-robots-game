extends Node2D

@onready var mobTimer = $MobTimer
@onready var leftPortal = $LeftPortal
@onready var rightPortal = $RightPortal
@onready var policeRobotScene = preload("res://scenes/Enemies/Police Robot/police_robot.tscn")
@onready var meleeNormalRobotScene = preload("res://scenes/Enemies/Melee Normal Robot/melee_normal_robot.tscn")
@onready var meleeWreckedRobotScene = preload("res://scenes/Enemies/Melee Wrecked Robot/melee_wrecked_robot.tscn")
@onready var rocketRobotScene = preload("res://scenes/Enemies/Rocket Robot/rocket_robot.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta: float) -> void:
	pass


func _on_mob_timer_timeout() -> void:
	var mobLeft = policeRobotScene.instantiate()
	var mobleft2 = meleeNormalRobotScene.instantiate()
	add_child(mobLeft)
	add_child(mobleft2)
	mobLeft.global_position = leftPortal.global_position
	mobleft2.global_position = leftPortal.global_position
	
	var mobRight = meleeWreckedRobotScene.instantiate()
	var mobright2 = rocketRobotScene.instantiate()
	add_child(mobRight)
	add_child(mobright2)
	mobRight.global_position = rightPortal.global_position
	mobright2.global_position = rightPortal.global_position
