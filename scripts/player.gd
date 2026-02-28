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
		
	if Input.is_action_pressed("attack"):
		$AnimatedSprite2D.play("attack")
	
	if not ($AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.is_playing()):
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
