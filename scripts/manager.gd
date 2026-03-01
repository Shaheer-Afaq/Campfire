extends Node

#var gameScene = preload("res://Scenes/game.tscn")
#var enemyScene = preload("res://Scenes/enemy.tscn")
#var player = preload("res://Scenes/player.tscn")

var lives: int = 3
var health: int = 50
var speed :int = 30
var jump_velocity: int = -500
var initial_position: Vector2 = Vector2(47, 36)
var last_checkpoint = initial_position
var checkpoints = []
	
func _process(delta: float) -> void:
	if lives <= 0:
		last_checkpoint = initial_position
		lives = 8
		checkpoints.clear()
		get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
