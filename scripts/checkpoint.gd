extends Area2D

func _ready() -> void:
	modulate = "ffffff"
		
func _on_body_entered(body: Node2D) -> void:
	if body.is_in_group("player"):
		body_entered.disconnect(_on_body_entered)
		modulate = "00ff69"
		$sound.play()
		Manager.last_checkpoint = position
		
