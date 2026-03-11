extends AnimatableBody2D

var start_pos
@export var offset: Vector2
@export var duration: float = 1.0
@export var delay: float = 0.5

func _ready():
	start_pos = position
	animate()

func animate():
	while true:
		var tween = create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self, "position", start_pos + offset * 16, duration)
		await tween.finished
		await get_tree().create_timer(delay).timeout
		
		tween = create_tween()
		tween.set_process_mode(Tween.TWEEN_PROCESS_PHYSICS)
		tween.tween_property(self, "position", start_pos, duration)
		await tween.finished
		await get_tree().create_timer(delay).timeout
