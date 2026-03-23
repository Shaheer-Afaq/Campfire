extends AnimatableBody2D

func _ready() -> void:
	$Area2D.monitoring = true

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	print("triggered")
	$Area2D.monitoring = false
	$AnimationPlayer.play("ro-ta-te")
