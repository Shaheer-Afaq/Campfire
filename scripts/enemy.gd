extends CharacterBody2D

enum State {IDLE, HURT, ATTACK, DIE}

var health = 9
var state = State.IDLE

func _ready() -> void:
	add_to_group("enemies")
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if state == State.DIE:
		return   # stop moving when dead
	
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	if state != State.ATTACK:
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				change_state(State.ATTACK)
				body.take_damage(5)
		
	move_and_slide()
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
	if state == State.HURT:
		change_state(State.IDLE)
	if state == State.DIE:
		queue_free()
	if state == State.ATTACK:
		change_state(State.IDLE)

#func _on_attack_hitbox_body_entered(body: Node2D) -> void:
	#if state != State.ATTACK and body.is_in_group("player"):
		#$AnimatedSprite2D.play("attack")
		#body.take_damage(10)
