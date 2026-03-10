extends Node2D

func _ready() -> void:
	$"CanvasLayer/Health Bar".max_value = Manager.TOTAL_HEALTH
	
func _process(delta: float) -> void:
	$"CanvasLayer/Health Bar".value = Manager.health
