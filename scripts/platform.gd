extends AnimatableBody2D

@export var start_pos: Vector2
@export var end_pos: Vector2
@export var duration: float 
@export var delay: float 

func _ready():
	position = start_pos


func _on_area_2d_body_entered(body: Node2D) -> void:
	if !body.is_in_group("player"):
		return
	$Area2D.monitoring = false
	print("triggered")
	var tween = create_tween()
	tween.tween_property(self, "position", end_pos, duration)
