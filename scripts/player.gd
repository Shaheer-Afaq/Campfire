extends CharacterBody2D

const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 2000

#func _ready() -> void:
func _physics_process(delta: float) -> void:
	velocity.x *= 0.89
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity
		
	if Input.is_action_pressed("attack") and not is_attacking():
		$AnimatedSprite2D.play("attack")
		$attack.play(0.0)
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				body.health -= 5  # damage over time
				body.$AnimatedSprite2D.play("idle")
	
	if not is_attacking():
		var direction := Input.get_axis("left", "right")
		velocity.x += direction * Manager.speed * delta * 60  # frame-independent

		if abs(velocity.x) > 30:
			if not $footsteps.playing:
				$footsteps.play(0.0)
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			
			$AnimatedSprite2D.play("run")
		else:
			$footsteps.stop()	
			$AnimatedSprite2D.play("idle")
		
	var collison = move_and_slide()
	#var touching_floor = is_on_floor()
	#var touching_ceiling = is_on_ceiling()
	#if touching_floor and touching_ceiling:
		#die()

func is_attacking():
	return $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.is_playing()

#func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	#if body.is_in_group("enemies"):
		#body.health -= 5
