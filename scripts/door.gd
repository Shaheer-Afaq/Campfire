extends TileMap

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
	print("triggered")
	var tween = create_tween()
	var tween2 = create_tween()
	tween.tween_property(self, "position", initial_position + offset * 16, duration)
	tween2.tween_property(self, "rotation_degrees", rotate, duration)
	#$Area2D.
