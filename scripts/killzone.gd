extends Area2D

@onready var player: CharacterBody2D = $"../../../Player"

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		player.take_damage(Manager.TOTAL_HEALTH)
