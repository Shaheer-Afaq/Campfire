extends CharacterBody2D

const GRAVITY = 2000

var state = "idle"

var attack_cooldown = 0
var has_attacked = false
var direction
var input_enabled = true
@onready var sprite: AnimatedSprite2D = $sprite

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint

func _physics_process(delta: float) -> void:
	if state == "die": return
	velocity.x *= 0.88

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if input_enabled and Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity
		state = "idle"
	
	elif input_enabled and Input.is_action_pressed("shield") and is_on_floor() and state != "attack":
		state = "shield"
		
	elif input_enabled and Input.is_action_pressed("attack") and state != "attack" and is_on_floor() and attack_cooldown == 0:
		state = "attack"
		$sprite.play(["attack", "attack1"].pick_random())
	
	if Input.is_action_just_released("shield"):
		state = "idle"
	
	direction = Input.get_axis("left", "right") if input_enabled else 0
	
	if !(state in ["shield", "attack"]): velocity.x += direction * Manager.speed * delta * 60
	else: velocity.x *= 0.9
	
	if not is_on_floor():
		$footsteps.stop()
		if velocity.y > 300 and sprite.animation != "down":
			$sprite.play("down")
		elif velocity.y < 0 and sprite.animation != "up":
			$sprite.play("up")
			
	elif state == "shield":
		$sprite.play("shield")
		
	elif state == "attack":
		if $sprite.frame == 2 and not has_attacked:
			has_attacked = true
			play_random_punch_sound()
			var target = is_enemy_in_attack_range()
			if target:
				target.take_damage(4, "", "")
		elif $sprite.frame == 6 and $sprite.animation == "attack1":
			play_random_punch_sound()
		
	elif state == "idle":
		sprite.play("idle")
		$footsteps.stop()
		if direction != 0 and not is_on_wall():
			state = "run"
	
	elif state == "run":
		if is_on_floor():
			sprite.play("run")
			if !$footsteps.playing and sprite.frame in [2,6]:
				$footsteps.stream = Manager.footsteps.pick_random()
				$footsteps.play()
			
		if abs(velocity.x) < 40:
			state = "idle"
	
	if !$footsteps.playing and sprite.animation == "run" and sprite.frame in [2,6]:
		$footsteps.stream = Manager.footsteps.pick_random()
		$footsteps.play()
	if attack_cooldown > 0: attack_cooldown -= 1
	if direction > 0: sprite.flip_h = false
	elif direction < 0: sprite.flip_h = true
	$attack_hitbox.position.x = -25 if $sprite.flip_h else 25
	$hitbox.position.x = 2 if $sprite.flip_h else -2
	
	move_and_slide()
		
func take_damage(amount, direction, source):
	if state == "die":
		return
	if source != "spikes" and state == "shield" and sprite.flip_h != direction:
		$shield.play()
		return
		
	Manager.health -= amount
	if Manager.health <= 0:
		state = "die"
		$hitbox.disabled = true
		$sprite.play("die")
		$deathsound.stream = Manager.player_die_sounds.pick_random()
		$deathsound.play()
		$footsteps.stop()
		Manager.allow_sounds = false
		#modulate = Color(1.0, 0.408, 0.399, 1.0)
	else:
		play_random_punch_sound()
		hurt_flash()

func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		"attack":
			has_attacked = false
			attack_cooldown = Manager.ATTACK_COOLDOWN
			state = "idle"
		"die":
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
		Color(1.0, 1.0, 1.0, 0.0),
		0.5
	)
	tween.finished.connect(func():
		Manager.lives -= 1
		if Manager.lives <= 0:
			get_tree().change_scene_to_file("res://Scenes/mainmenu.tscn")
			queue_free()
		else:
			respawn()
	)
		
func is_enemy_in_attack_range():
	for body in $attack_hitbox.get_overlapping_bodies():
		if body.is_in_group("enemies"):
			return body
	return false

func respawn():
	velocity.x = 0
	Manager.allow_sounds = false
	Manager.health = Manager.TOTAL_HEALTH
	position = Manager.last_checkpoint
	state = "idle"
	$hitbox.disabled = false
	var tween = create_tween()
	tween.tween_property(
		$sprite,
		"modulate",
		Color(0.0, 0.0, 0.0, 0.0),
		0.0
	)
	tween.tween_property(
		$sprite,
		"modulate",
		Color(1.0, 1.0, 1.0, 1.0),
		0.3
	)
	tween.finished.connect(func():
		Manager.allow_sounds = true
	)
	
func play_random_punch_sound():
	$attacksound.stream = Manager.attack_sounds.pick_random()
	$attacksound.play()
