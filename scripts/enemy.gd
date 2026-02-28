extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

func _ready() -> void:
	add_to_group("enemies")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func _process(delta: float) -> void:
	$AnimatedSprite2D.play("idle")
