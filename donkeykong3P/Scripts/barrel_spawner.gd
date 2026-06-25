extends Node2D

const BARREL := preload("res://Scenes/barrel.tscn")
const KONG_LEFT := preload("res://Assets/Kong_Left.png")
const KONG_FRONT := preload("res://Assets/Kong_Front.png")
const KONG_RIGHT := preload("res://Assets/Kong_Right.png")
const KONG_THROW_FRAME_TIME := 0.18
const BARREL_SPAWN_OFFSET := Vector2(52, 0)

@export var spawn_interval := 2.0
@export var barrel_speed := 200.0

@onready var timer: SpawnTimer = $SpawnTimer
@onready var player: Player = $"../Player"
@onready var kong_sprite: Sprite2D = $"../Kong"

var started := false
var spawning := false
var stopped_for_win := false
var kong_default_texture: Texture2D


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timeout)
	player.game_started.connect(_on_game_started)
	kong_default_texture = kong_sprite.texture


func stop_for_win() -> void:
	stopped_for_win = true
	spawning = false
	timer.stop()
	kong_sprite.texture = kong_default_texture

func _on_game_started() -> void:
	if started:
		return
	started = true
	_spawn_barrel()


func _on_timeout() -> void:
	_spawn_barrel()


func _spawn_barrel() -> void:
	if spawning or stopped_for_win or player.dead:
		return

	spawning = true
	var can_spawn := await _play_kong_throw_animation()
	if not can_spawn:
		spawning = false
		return

	var barrel := BARREL.instantiate() as Barrel
	barrel.speed = barrel_speed
	barrel.position = BARREL_SPAWN_OFFSET
	add_child(barrel)

	spawning = false
	timer.setup()


func _play_kong_throw_animation() -> bool:
	for texture in [KONG_LEFT, KONG_FRONT, KONG_RIGHT]:
		if stopped_for_win or player.dead:
			kong_sprite.texture = kong_default_texture
			return false
		kong_sprite.texture = texture
		await get_tree().create_timer(KONG_THROW_FRAME_TIME).timeout

	kong_sprite.texture = kong_default_texture
	return not stopped_for_win and not player.dead
