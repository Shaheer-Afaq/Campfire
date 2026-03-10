extends Node

const game = preload("res://scenes/game.tscn")
const player = preload("res://scenes/player.tscn")

const footsteps = [
	preload("res://assets/sounds/footsteps/foot1.MP3"),
	preload("res://assets/sounds/footsteps/foot2.MP3"),
	preload("res://assets/sounds/footsteps/foot3.MP3"),
	preload("res://assets/sounds/footsteps/foot4.MP3"),
	preload("res://assets/sounds/footsteps/foot5.MP3"),
	preload("res://assets/sounds/footsteps/foot6.MP3"),
	preload("res://assets/sounds/footsteps/foot7.MP3"),
	preload("res://assets/sounds/footsteps/foot8.MP3"),
	preload("res://assets/sounds/footsteps/foot9.MP3")
]
const attack_sounds = [
	preload("res://assets/sounds/attacks/punch1.wav"),
	preload("res://assets/sounds/attacks/punch2.wav"),
	preload("res://assets/sounds/attacks/punch3.wav"),
	preload("res://assets/sounds/attacks/punch4.wav"),
	preload("res://assets/sounds/attacks/punch5.wav"),
	preload("res://assets/sounds/attacks/punch6.wav"),
	preload("res://assets/sounds/attacks/punch7.wav"),
	preload("res://assets/sounds/attacks/punch8.wav"),
	preload("res://assets/sounds/attacks/punch9.wav")
]
const enemy_die_sounds = [
	preload("res://assets/sounds/enemy/die.mp3")
]
const player_die_sounds = [
	preload("res://assets/sounds/player/die.wav")
]

const TOTAL_HEALTH = 100
const ATTACK_COOLDOWN = 5 #frame
var health
var checkpoints = []
var lives: int
var speed :int = 25
var jump_velocity: int = -500
var initial_position: Vector2 = Vector2(35, 120)
var last_checkpoint = initial_position
var allow_sounds = false
var Player
var Game

func restart():
	Player = player.instantiate()
	Game = game.instantiate()
	checkpoints.clear()
	lives = 2
	get_tree().change_scene_to_node(Game)
	Game.add_child(Player)
	Player.position = initial_position
	Player.respawn()
	
	
