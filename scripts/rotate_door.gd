extends AnimatableBody2D

var initial_rotation
@export var rotate: float
@export var duration: float

func _ready():
	initial_rotation = rotation_degrees

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	$Area2D.monitoring = false
	print("triggered")
	var tween = create_tween()
	tween.tween_property(self, "rotation_degrees", initial_rotation + rotate, duration)
