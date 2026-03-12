extends Node2D

func _ready() -> void:
	$"CanvasLayer/Health Bar".max_value = Manager.TOTAL_HEALTH
	
func _process(delta: float) -> void:
	$"CanvasLayer/Health Bar".value = Manager.health


func _on_winarea_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		Manager.Player.input_enabled =  false
		$winsound.play()
		


func _on_winsound_finished() -> void:
	get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
