extends AnimatableBody2D

var count: int

func _ready():
	$Area2D.monitoring = true
	count = 0

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return 
	print("triggered")
	print(count) 
	$Area2D.monitoring = false
	$AnimationPlayer.play("rotate")
	#$AnimationPlayer.autoplay
	#count += 1
