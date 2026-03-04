extends CharacterBody2D

enum State {IDLE, HURT, ATTACK, DIE, CHASE}

var health = 9
var state = State.IDLE
var target
var speed = 30
var player
var has_attacked = false
var attack_cooldown = 0

var attack_sounds = [
	preload("res://assets/skeleton/sounds/attack1.wav"),
	preload("res://assets/skeleton/sounds/attack2.mp3")
]
var die_sounds = [
	preload("res://assets/skeleton/sounds/die.wav")
]
func _ready() -> void:
	add_to_group("enemies")
	player = $"../../Player"

func _physics_process(delta: float) -> void:
	velocity.x = 0
	if state == State.DIE:
		return
	var direction = 0
			
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	if state == State.ATTACK:
		if $sprite.frame == 5 and not has_attacked:
			has_attacked = true
			$attacksound.stream = attack_sounds.pick_random()
			$attacksound.play()
			if is_player_in_attack_range():
				player.take_damage(3)
		

	elif state == State.CHASE:
		var player_pos = player.position
		direction = sign(player_pos.x - position.x)
		$sprite.flip_h = direction < 0
		
		if is_on_wall():
			
			$sprite.play("idle")

		if is_player_in_attack_range():
			if attack_cooldown == 0:
				change_state(State.ATTACK)
		else:
			velocity.x = direction * speed
		
		if attack_cooldown > 0: attack_cooldown -= 1
		#for body in $attack_hitbox.get_overlapping_bodies():
			#if body.is_in_group("player"):
				#target = body
				#change_state(State.ATTACK)
				#break
	
	if state != State.ATTACK:
		if is_player_in_range():
			change_state(State.CHASE)
		else:
			change_state(State.IDLE)
			direction = 0
	
	velocity.x = direction * 30
	move_and_slide()
	
	$attack_hitbox.position.x = -20 if $sprite.flip_h else 20

func _process(delta: float) -> void:
	if health <= 0 and state != State.DIE:
		change_state(State.DIE)

func take_damage(amount):
	if state == State.DIE:
		return
	health -= amount
	
	if health <= 0:
		change_state(State.DIE)
		$deathsound.stream = die_sounds.pick_random()
		$deathsound.play()
	else:
		hurt_flash()

func change_state(new_state):
	if state == new_state:
		return
	state = new_state
	
	match state:
		State.IDLE:
			$sprite.play("idle")
		State.HURT:
			#$sprite.play("hurt")
			hurt_flash()
		State.CHASE:
			$sprite.play("walk")
		State.ATTACK:
			$sprite.play("attack")
		State.DIE:
			modulate = Color(0.6, 0.0, 0.1, 1.0)
			$sprite.play("die")
			
func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		State.ATTACK:
			has_attacked = false
			attack_cooldown = 10
			change_state(State.CHASE)
		#State.HURT:
			#change_state(State.IDLE)
		State.DIE:
			queue_free()
			
func hurt_flash():
	var tween = create_tween()
	tween.tween_property(
		$sprite,
		"modulate",
		Color(0.6, 0.0, 0.1, 1.0),
		0.1
	)
	tween.tween_property(
		$sprite,
		"modulate",
		Color(1, 1, 1),
		0.1
	)

func is_player_in_range():
	for body in $range.get_overlapping_bodies():
			if body.is_in_group("player"):
				target = body
				return true
	return false
	
func is_player_in_attack_range():
	for body in $attack_hitbox.get_overlapping_bodies():
			if body.is_in_group("player"):
				return true
	return false
