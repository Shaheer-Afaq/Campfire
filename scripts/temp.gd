extends CharacterBody2D

const GRAVITY = 2000

enum State {IDLE, RUN, ATTACK, HURT, DIE, UP, DOWN}
var state = State.IDLE
var attack_sounds = [
	preload("res://assets/player/sounds/punch1.wav"),
	preload("res://assets/player/sounds/punch2.wav"),
	preload("res://assets/player/sounds/punch3.wav"),
	preload("res://assets/player/sounds/punch4.wav"),
	preload("res://assets/player/sounds/punch5.wav"),
	preload("res://assets/player/sounds/punch6.wav"),
	preload("res://assets/player/sounds/punch7.wav")
]
var attack_cooldown = 0
var has_attacked = false

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint
	change_state(State.IDLE)
	#$hitbox.disabled = false

func _physics_process(delta: float) -> void:
	if state == State.DIE: return
	velocity.x *= 0.88

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity

	if not is_on_floor():
		if velocity.y > 300:
			change_state(State.DOWN)
		elif velocity.y < 0:
			change_state(State.UP)
	else:
		if state in [State.UP, State.DOWN]:
			change_state(State.IDLE)

	if Input.is_action_pressed("attack") and state != State.ATTACK and is_on_floor() and attack_cooldown == 0:
		change_state(State.ATTACK)

	if attack_cooldown > 0: attack_cooldown -= 1

	if state == State.ATTACK:
		if $sprite.frame == 2 and not has_attacked:
			has_attacked = true
			$attacksound.stream = attack_sounds.pick_random()
			$attacksound.play()
			var target = is_enemy_in_attack_range()
			if target:
				target.take_damage(3)
		elif $sprite.frame == 6 and $sprite.animation == "attack1":
			$attacksound.stream = attack_sounds.pick_random()
			$attacksound.play()

	else:
		var direction := Input.get_axis("left", "right")
		velocity.x += direction * Manager.speed * delta * 60

		if is_on_floor():
			if abs(velocity.x) > 30:
				change_state(State.RUN)
				if not $footsteps.playing:
					$footsteps.play(0.03)
				$sprite.flip_h = velocity.x < 0
			else:
				change_state(State.IDLE)
				$footsteps.stop()
		else: $footsteps.stop()
		$sprite.flip_h = velocity.x < 0

	$attack_hitbox.position.x = -25 if $sprite.flip_h else 25
	$hitbox.position.x = -2 if $sprite.flip_h else 2

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
		hurt_flash()

func change_state(new_state):
	if state == new_state:
		return
	state = new_state

	match state:
		State.IDLE:
			$sprite.play("idle")
		State.RUN:
			$sprite.play("run")
		State.UP:
			$sprite.play("up")
		State.DOWN:
			$sprite.play("down")
		State.ATTACK:
			$sprite.play(["attack", "attack1"].pick_random())
		State.DIE:
			$hitbox.disabled = true
			$sprite.play("die")
			$deathsound.play(0.0)
			modulate = Color(1.0, 0.408, 0.399, 1.0)

func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		State.ATTACK:
			has_attacked = false
			attack_cooldown = Manager.ATTACK_COOLDOWN
			change_state(State.IDLE)
		State.HURT:
			change_state(State.IDLE)
		State.DIE:
			die_fade()

func hurt_flash():
	var tween = create_tween()
	tween.tween_property(
		$sprite,
		"modulate",
		Color(0.6, 0.0, 0.1, 1.0),
		0.05
	)
	tween.tween_property(
		$sprite,
		"modulate",
		Color(1, 1, 1),
		0.2
	)

func die_fade():
	var tween = create_tween()
	tween.tween_property(
		$sprite,
		"modulate",
		Color(0.6, 0.0, 0.1, 0.0),
		1.5
	)
	tween.finished.connect(func():
		Manager.lives -= 1
		get_tree().reload_current_scene()
	)
		
func is_enemy_in_attack_range():
	for body in $attack_hitbox.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			return body
	return false
