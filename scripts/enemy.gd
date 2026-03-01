extends CharacterBody2D

var health = 20
var is_dead = false

func _ready() -> void:
	add_to_group("enemies")
	$AnimatedSprite2D.play("idle")
	
func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity += get_gravity() * delta
	move_and_slide()
	$attack_hitbox.position.x = -25 if $AnimatedSprite2D.flip_h else 25
	
func _process(delta: float) -> void:
	if health <= 0:
		$AnimatedSprite2D.play("die")
	
func take_damage():
	health -= 3
	print(health)
	if 
	$AnimatedSprite2D.play("hurt")  # or "idle" if you want

	
func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "hurt":
		$AnimatedSprite2D.play("idle")
	if $AnimatedSprite2D.animation == "die":
		queue_free()

func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	if not is_attacking() and body.is_in_group("player"):
		body.take_damage()

func is_attacking():
	return $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.is_playing()
	
func is_dying():
	return $AnimatedSprite2D.animation == "die" and $AnimatedSprite2D.is_playing()
	
func is_being_hurt():
	return $AnimatedSprite2D.animation == "hurt" and $AnimatedSprite2D.is_playing()
