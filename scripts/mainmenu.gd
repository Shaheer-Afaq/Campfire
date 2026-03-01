extends Node2D

func _on_start_pressed() -> void:
	Manager.checkpoints.clear()
	Manager.last_checkpoint = Manager.initial_position
	Manager.health = 50
	Manager.speed = 30
	Manager.jump_velocity = -400
	get_tree().change_scene_to_file("res://Scenes/game.tscn")

func _on_exit_pressed() -> void:
	get_tree().quit()
