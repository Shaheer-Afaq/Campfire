extends CharacterBody2D

enum State {IDLE, HURT, ATTACK, DIE}

var health = 9
var state = State.IDLE

func _ready() -> void:
	add_to_group("enemies")
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if state == State.DIE:
		return
	
	# gravity
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	# attack trigger (damage BEFORE animation)
	if state == State.IDLE:
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				body.take_damage(5)   # damage immediately
				change_state(State.ATTACK)
				break
	
	move_and_slide()
	
	# flip hitbox
	$attack_hitbox.position.x = -11.5 if $AnimatedSprite2D.flip_h else 11.5


func _process(delta: float) -> void:
	if health <= 0 and state != State.DIE:
		change_state(State.DIE)


func take_damage():
	if state == State.DIE:
		return
	
	health -= 3
	print(health)
	
	if health <= 0:
		change_state(State.DIE)
	else:
		change_state(State.HURT)


func change_state(new_state):
	if state == new_state:
		return
	
	state = new_state
	
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("idle")
		
		State.HURT:
			$AnimatedSprite2D.play("hurt")
		
		State.ATTACK:
			$AnimatedSprite2D.play("attack")
		
		State.DIE:
			$AnimatedSprite2D.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		
		State.ATTACK:
			# After animation, check again
			for body in $attack_hitbox.get_overlapping_bodies():
				if body.is_in_group("player"):
					body.take_damage(5)  # repeat damage
					change_state(State.ATTACK)
					return
			
			change_state(State.IDLE)
		
		State.HURT:
			change_state(State.IDLE)
		
		State.DIE:
			queue_free()
