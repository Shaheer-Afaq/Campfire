extends CharacterBody2D


const SPEED = 300.0
const JUMP_VELOCITY = -400.0
const GRAVITY = 2000

func _physics_process(delta: float) -> void:
	#if is_dead:
		#if $AnimatedSprite2D.frame == 28:
			#Manager.lives -= 1
			#get_tree().reload_current_scene()
		#else: return
		
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity
		
	velocity.x *= 0.89

	var direction := Input.get_axis("left", "right")
	velocity.x += direction * Manager.speed * delta * 60  # frame-independent

		# Animations
	if abs(velocity.x) > 30:
		if velocity.x > 0:
			$AnimatedSprite2D.flip_h = false
		else:
			$AnimatedSprite2D.flip_h = true
		$AnimatedSprite2D.play("run")
	else:
		$AnimatedSprite2D.play("idle")

	var collison = move_and_slide()
	#var touching_floor = is_on_floor()
	#var touching_ceiling = is_on_ceiling()
	#if touching_floor and touching_ceiling:
		#die()
