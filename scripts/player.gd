extends CharacterBody2D

const GRAVITY = 2000
var is_dead = false

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint
	
func _physics_process(delta: float) -> void:
	if is_dead:
		if $AnimatedSprite2D.frame == 22:
			Manager.lives -= 1
			get_tree().reload_current_scene()
		else: return
		
	velocity.x *= 0.87
	
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity
		
	if Input.is_action_pressed("attack") and not is_attacking():
		$AnimatedSprite2D.play("attack")
		$attack.play(0.0)
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				body.take_damage()
	
	if not is_attacking():
		var direction := Input.get_axis("left", "right")
		velocity.x += direction * Manager.speed * delta * 60
		
		if abs(velocity.x) > 30:
			if not $footsteps.playing and is_on_floor():
				$footsteps.play(0.0)
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
			
			$AnimatedSprite2D.play("run")
		else:
			$footsteps.stop()	
			$AnimatedSprite2D.play("idle")
			
		$attack_hitbox.position.x = -25 if $AnimatedSprite2D.flip_h else 25
		
	var collison = move_and_slide()
	#var touching_floor = is_on_floor()
	#var touching_ceiling = is_on_ceiling()
	#if touching_floor and touching_ceiling:
		#die()


func take_damage(amount):
	Manager.health -= 5
	if not is_being_hurt(): $AnimatedSprite2D.play("hurt")
	
func die() -> void:
	if is_dying(): return
	$AnimatedSprite2D.play("die")
	$hurt.play(0.2)
	
func is_attacking():
	return $AnimatedSprite2D.animation == "attack" and $AnimatedSprite2D.is_playing()
	
func is_dying():
	return $AnimatedSprite2D.animation == "die" and $AnimatedSprite2D.is_playing()

func is_being_hurt():
	return $AnimatedSprite2D.animation == "hurt" and $AnimatedSprite2D.is_playing()
	

func _on_animated_sprite_2d_animation_finished() -> void:
	if $AnimatedSprite2D.animation == "die":
		Manager.lives -= 1
