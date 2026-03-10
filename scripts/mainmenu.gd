extends Node2D

func _ready() -> void:
	$controls.visible = false

func _on_start_pressed() -> void:
	$Click.play()
	await get_tree().create_timer(0.2).timeout
	Manager.restart()

func _on_exit_pressed() -> void:
	get_tree().quit()

func _on_controls_pressed() -> void:
	$Click.play()
	$controls.visible = true
	$bg.modulate = Color(0.158, 0.158, 0.158, 1.0)	

func _on_back_pressed() -> void:
	$Click.play()
	$controls.visible = false
	$bg.modulate = Color(1.0, 1.0, 1.0, 1.0)	
	
