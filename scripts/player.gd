extends CharacterBody2D

const GRAVITY = 2000

enum State {IDLE, RUN, ATTACK, HURT, DIE, UP, DOWN}
var state = "idle"
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
@onready var sprite: AnimatedSprite2D = $sprite

func _ready() -> void:
	add_to_group("player")
	position = Manager.last_checkpoint

func _physics_process(delta: float) -> void:
	if state == "die": return
	velocity.x *= 0.88

	if not is_on_floor():
		velocity.y += GRAVITY * delta

	if Input.is_action_pressed("jump") and is_on_floor():
		velocity.y = Manager.jump_velocity
		#state = "jump"
	
	var direction := Input.get_axis("left", "right")
	velocity.x += direction * Manager.speed * delta * 60
	
	#if state == "jump":
	if velocity.y < 0:
		sprite.play("up")
	elif velocity.y > 0:
		sprite.play("down")
		
	elif state == "idle":
		sprite.play("idle")
		$footsteps.stop()
		if direction != 0 and not is_on_wall():
			state = "run"
	
	elif state == "run":
		if is_on_floor():
			sprite.play("run")
		if not $footsteps.playing:
			$footsteps.play(0.03)
		if abs(velocity.x) < 40:
			state = "idle"
	
	if direction > 0: sprite.flip_h = false
	elif direction < 0: sprite.flip_h = true
	$attack_hitbox.position.x = -25 if $sprite.flip_h else 25
	$hitbox.position.x = -2 if $sprite.flip_h else 2

	move_and_slide()

func _process(delta: float) -> void:
	$"../CanvasLayer/Health Bar".value = Manager.health

func take_damage(amount):
	if state == "die":
		return
	Manager.health -= amount
	if Manager.health <= 0:
		state = "die"
		$hitbox.disabled = true
		$sprite.play("die")
		$deathsound.play(0.0)
		modulate = Color(1.0, 0.408, 0.399, 1.0)
	else:
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
