extends Node2D

func _ready() -> void:
	Manager.health = Manager.TOTAL_HEALTH
	$Player.position = Vector2(5200, 900)
	$"CanvasLayer/Health Bar".max_value = Manager.TOTAL_HEALTH
func _process(delta: float) -> void:
	pass
	#print(Manager.lives)
