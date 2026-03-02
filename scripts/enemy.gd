extends CharacterBody2D

enum State {IDLE, HURT, ATTACK, DIE, CHASE}

var health = 9
var state = State.IDLE
var target

func _ready() -> void:
	add_to_group("enemies")

func _physics_process(delta: float) -> void:
	if state == State.DIE:
		return
	var direction = 0
			
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if state == State.ATTACK:
		if $AnimatedSprite2D.frame == 5:
			$"../Player".take_damage(20 * delta)

	elif state == State.CHASE:
		var player_pos = $"../Player".position
		direction = sign(player_pos.x - position.x)
		$AnimatedSprite2D.flip_h = direction < 0
		velocity.x = direction * 100

		if is_on_wall():
			velocity.x = 0
			$AnimatedSprite2D.play("idle")
		#else:
			#if $AnimatedSprite2D.animation != "walk":
				#$AnimatedSprite2D.play("walk")
		if is_player_in_attack_range():
			change_state(State.ATTACK)
		for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				target = body
				change_state(State.ATTACK)
				break
	
	if state != State.ATTACK:
		if is_player_in_range():
			change_state(State.CHASE)
		else:
			change_state(State.IDLE)
			direction = 0
	
	velocity.x = direction * 30
	
	move_and_slide()
	
	$attack_hitbox.position.x = -20 if $AnimatedSprite2D.flip_h else 20

func _process(delta: float) -> void:
	if health <= 0 and state != State.DIE:
		change_state(State.DIE)

func take_damage(amount):
	if state == State.DIE:
		return
	health -= amount
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
			hurt_flash()
		State.CHASE:
			$AnimatedSprite2D.play("walk")
		State.ATTACK:
			$AnimatedSprite2D.play("attack")
		State.DIE:
			modulate = Color(0.6, 0.0, 0.1, 1.0)
			$AnimatedSprite2D.play("die")
			
func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		State.ATTACK:
			change_state(State.CHASE)
		State.HURT:
			change_state(State.IDLE)
		State.DIE:
			queue_free()
			
func hurt_flash():
	var tween = create_tween()
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(0.6, 0.0, 0.1, 1.0),
		0.1
	)
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(1, 1, 1),
		0.1
	)

func is_player_in_range():
	for body in $range.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	return false
	
func is_player_in_attack_range():
	for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	return false
