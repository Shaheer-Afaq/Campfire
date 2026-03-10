extends Area2D

func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player") or body.is_in_group("enemies"):
		body.take_damage(999, true, "spikes")
