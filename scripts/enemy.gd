extends CharacterBody2D

var health = 9
var state = "idle"
var target
var speed = 100
var player
var has_attacked = false
var attack_cooldown: int = 0
var direction = 0
var attacks = ["attack1","attack2","attack3"]
var ready_for_sound = false
@onready var sprite: AnimatedSprite2D = $sprite


func _ready() -> void:
	add_to_group("enemies")
	player = $"../../Player"
	scale = Vector2.ONE * randf_range(0.6, 0.8)
	await get_tree().process_frame
	ready_for_sound = true

func _physics_process(delta: float) -> void:
	if state == "die": return
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		"attack":
			direction = 0
			if !(sprite.animation in attacks):
				sprite.play(attacks.pick_random())
			if $sprite.frame == 3 and not has_attacked:
				has_attacked = true
				$attacksound.stream = Manager.attack_sounds.pick_random()
				$attacksound.play()
				if is_player_in_attack_range():
					player.take_damage(3)
		"idle":
			direction = 0
			if is_player_in_range():
				state = "chase"
			else:
				sprite.play("idle")
		
		"chase":
			if not is_player_in_range():
				state = "idle"
			elif is_player_in_attack_range():
				if attack_cooldown == 0:
					state = "attack"
			else:
				var player_pos = player.position
				direction = sign(player_pos.x - position.x)
				if is_on_wall():
					sprite.play("idle")
				else:
					sprite.play("run")
					if !$footsteps.playing and sprite.frame in [2,5]:
						$footsteps.stream = Manager.footsteps.pick_random()
						$footsteps.play()
					
		
	if attack_cooldown > 0: attack_cooldown -= 1
	if direction > 0: sprite.flip_h = false
	elif direction < 0: sprite.flip_h = true
	$attack_hitbox.position.x = -16 if $sprite.flip_h else 16
	velocity.x = direction * speed
	move_and_slide()
	if sprite.animation == "run": sprite.offset.x = -9 if sprite.flip_h else 9
	else: sprite.offset.x = 0

func _process(delta: float) -> void:
	if health <= 0 and state != "die":
		state = "die"

func take_damage(amount):
	if state == "die":
		return
	health -= amount
	
	if health <= 0:
		state = "die"
		$hitbox.disabled = true
		modulate = Color(0.6, 0.0, 0.1, 1.0)
		$sprite.play("die")
		$deathsound.stream = Manager.enemy_die_sounds.pick_random()
		$deathsound.play()
	else:
		hurt_flash()
			
func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		"attack":
			attack_cooldown = 15
			has_attacked = false
			state = "chase"
			sprite.play("idle")
			
func _on_deathsound_finished() -> void:
	queue_free()

#func die_fade():
	#var tween = create_tween()
	#tween.tween_property(
		#$sprite,
		#"modulate",
		#Color(0.6, 0.0, 0.1, 0.0),
		#1.5
	#)
	
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


func _on_range_body_entered(body: Node2D) -> void:
	if ready_for_sound and !$chargesound.playing and body.is_in_group("player"):
		$chargesound.pitch_scale = remap(scale.x, 0.6, 0.8, 1.4, 0.6)
		$chargesound.play()
