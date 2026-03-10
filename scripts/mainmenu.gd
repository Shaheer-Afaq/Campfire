extends Node2D

func _on_start_pressed() -> void:
	$Click.play()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_click_finished() -> void:
	Manager.restart()
