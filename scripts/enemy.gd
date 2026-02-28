extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0

var health = 20

func _ready() -> void:
	add_to_group("enemies")
	$AnimatedSprite2D.play("idle")
	
func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta

	move_and_slide()
	
func _process(delta: float) -> void:
	pass
	
func take_damage():
	health -= 3
	print(health)
	$AnimatedSprite2D.play("hurt")  # or "idle" if you want


func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "hurt":
		$AnimatedSprite2D.play("idle")
