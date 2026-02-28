extends CharacterBody2D

var initial_position
func _ready() -> void:
	initial_position = position

func _on_trigger_activated(state):
	var tween = create_tween()
	if state == "open":
		tween.tween_property(self, "position", initial_position-32, 1)
		
