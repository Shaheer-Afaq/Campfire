extends AnimatableBody2D

var initial_position
var initial_rotation
@export var offset: Vector2
@export var rotate: float
@export var duration: float

func _ready():
	initial_position = position
	initial_rotation = rotation_degrees

func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	$Area2D.monitoring = false
	print("triggered")
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position + offset * 16, duration)
