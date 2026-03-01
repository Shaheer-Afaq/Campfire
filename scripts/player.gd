extends CharacterBody2D 

const GRAVITY = 2000

enum State {IDLE, RUN, ATTACK, HURT, DIE}
var state = State.IDLE

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint
	change_state(State.IDLE)

func _physics_process(delta: float) -> void:
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

	if state != State.ATTACK:
		var direction := Input.get_axis("left", "right")
		velocity.x += direction * Manager.speed * delta * 60
		
		if abs(velocity.x) > 30:
			change_state(State.RUN)
			if not $footsteps.playing and is_on_floor():
				$footsteps.play()
			$AnimatedSprite2D.flip_h = velocity.x < 0
		else:
			change_state(State.IDLE)
			$footsteps.stop()
	
	$attack_hitbox.position.x = -25 if $AnimatedSprite2D.flip_h else 25
	
	move_and_slide()

func _process(delta: float) -> void:
	$"../CanvasLayer/Health Bar".value = Manager.health

func take_damage(amount):
	if state == State.DIE:
		return
	Manager.health -= amount
	if Manager.health <= 0:
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
		State.RUN:
			$AnimatedSprite2D.play("run")
		State.ATTACK:
			$AnimatedSprite2D.play("attack")
		State.HURT:
			hurt_flash()
		State.DIE:
			$AnimatedSprite2D.play("die")

func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		State.ATTACK:
			change_state(State.IDLE)
		State.HURT:
			change_state(State.IDLE)
		State.DIE: 
			Manager.lives -= 1
			get_tree().reload_current_scene()

func hurt_flash():
	var tween = create_tween()
	
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(0.6, 0.0, 0.1, 1.0),
		0.05
	)
	tween.tween_property(
		$AnimatedSprite2D,
		"modulate",
		Color(1, 1, 1),
		0.2
	)
	#tween.finished.connect(func(): change_state(State.IDLE))
	tween.finished.connect(func(): print(1))
