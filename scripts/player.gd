extends CharacterBody2D

const GRAVITY = 2000
enum State {IDLE,RUN,ATTACK,HURT,DIE}
var state = State.IDLE

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
	if state == State.DIE:
		if $AnimatedSprite2D.frame == 22:
			Manager.lives -= 1
			get_tree().reload_current_scene()
		return
	
	velocity.x *= 0.88
	if not is_on_floor():
		velocity.y += GRAVITY * delta
	
	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity

	if Input.is_action_just_pressed("attack") and state != State.ATTACK:
		change_state(State.ATTACK)
		$attack.play(0.0)
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("enemies"):
				body.take_damage()

	if state not in [State.ATTACK, State.DIE]:

		var direction := Input.get_axis("left", "right")

		velocity.x += direction * Manager.speed * delta * 60

		if abs(velocity.x) > 30:
			change_state(State.RUN)
			if not $footsteps.playing and is_on_floor():
				$footsteps.play()
			if velocity.x > 0:
				$AnimatedSprite2D.flip_h = false
			else:
				$AnimatedSprite2D.flip_h = true
		else:
			change_state(State.IDLE)
			$footsteps.stop()
			
	$attack_hitbox.position.x = -25 if $AnimatedSprite2D.flip_h else 25
	move_and_slide()

func take_damage(amount):
	if state == State.DIE:
		return
	Manager.health -= amount	
	change_state(State.HURT)
	#if Manager.health <= 0:
		#die()
	#else:
		#change_state(State.HURT)

func die():
	if state == State.DIE:
		return
	
	change_state(State.DIE)
	#$hurt.play(0.2)

func change_state(new_state):
	if state == new_state:
		return
		
	state = new_state
	
	match state:
		State.IDLE:
			$AnimatedSprite2D.play("idle")
		
		State.RUN:
			$AnimatedSprite2D.play("run")
		
		State.ATTACK:
			$AnimatedSprite2D.play("attack")
		
		State.HURT:
			hurt_animation()
			print(1)
		
		State.DIE:
			$AnimatedSprite2D.play("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		State.ATTACK:
			change_state(State.IDLE)
		State.HURT:
			change_state(State.IDLE)
			
func hurt_animation():
	var tween = create_tween()
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(0.612, 0.0, 0.086, 1.0),
		0.1
	)
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(1, 1, 1),
		0.1
	)
	tween.finished.connect(_on_animated_sprite_2d_animation_finished)
