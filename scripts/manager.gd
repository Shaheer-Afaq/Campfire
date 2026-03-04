extends Node

#var gameScene = preload("res://Scenes/game.tscn")
#var enemyScene = preload("res://Scenes/enemy.tscn")

const TOTAL_HEALTH = 40
const ATTACK_COOLDOWN = 1 #frame
var lives: int = 3
var health
var speed :int = 25
var jump_velocity: int = -400
var initial_position: Vector2 = Vector2(47, 36)
var last_checkpoint = initial_position
var checkpoints = []
	
func _process(delta: float) -> void:
	if lives <= 0:
		last_checkpoint = initial_position
		lives = 8
		checkpoints.clear()
		get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
