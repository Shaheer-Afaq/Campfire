extends CharacterBody2D

var health = 9
var state = "idle"
var target
var speed = 30
var player
var has_attacked = false
var attack_cooldown: int = 0
var direction = 0
@onready var sprite: AnimatedSprite2D = $sprite

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
	if not is_on_floor():
		velocity += get_gravity() * delta
	
	match state:
		"attack":
			direction = 0
			sprite.play("attack")
			if $sprite.frame == 5 and not has_attacked:
				has_attacked = true
				$attacksound.stream = attack_sounds.pick_random()
				$attacksound.play()
				if is_player_in_attack_range():
					player.take_damage(3)
		"idle":
			direction = 0
			if is_player_in_range():
				state = "chase"
			else:
				#state = "idle"
				sprite.play("idle")
		
		"chase":
			if not is_player_in_range():
				state = "idle"
			elif is_player_in_attack_range():
				state = "attack"
			else:
				var player_pos = player.position
				direction = sign(player_pos.x - position.x)
				if is_on_wall():
					sprite.play("idle")
				else:
					sprite.play("walk")
					
		
	
	if direction > 0: sprite.flip_h = false
	elif direction < 0: sprite.flip_h = true
	$attack_hitbox.position.x = -20 if $sprite.flip_h else 20
	velocity.x = direction * speed
	move_and_slide()

func _process(delta: float) -> void:
	if health <= 0 and state != "die":
		state = "die"

func take_damage(amount):
	if state == "die":
		return
	health -= amount
	
	if health <= 0:
		state = "die"
		modulate = Color(0.6, 0.0, 0.1, 1.0)
		$sprite.play("die")
		$deathsound.stream = die_sounds.pick_random()
		$deathsound.play()
	else:
		hurt_flash()
			
func _on_animated_sprite_2d_animation_finished() -> void:
	match state:
		"attack":
			attack_cooldown = 10
			has_attacked = false
			state = "chase"

		"die":
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
