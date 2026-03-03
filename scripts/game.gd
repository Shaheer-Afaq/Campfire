extends Node2D

func _ready() -> void:
	Manager.health = Manager.TOTAL_HEALTH
	$Player.position = Vector2(180, 300)
	$"CanvasLayer/Health Bar".max_value = Manager.TOTAL_HEALTH
func _process(delta: float) -> void:
	print(Manager.lives)
