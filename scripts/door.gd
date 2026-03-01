extends Node2D

var initial_position
@export var offset: Vector2
@export var duration: float
func _ready():
	initial_position = position
	pass

func _on_area_2d_body_entered(body: Node2D) -> void:
	var tween = create_tween()
	tween.tween_property(self, "position", initial_position + offset, duration)
