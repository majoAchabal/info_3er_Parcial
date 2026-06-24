extends Node2D

const BARREL := preload("res://Scenes/barrel.tscn")

@export var spawn_interval := 2.0
@export var barrel_speed := 200.0

@onready var timer: SpawnTimer = $SpawnTimer
@onready var player: Player = $"../Player"

var started := false


func _ready() -> void:
	timer.wait_time = spawn_interval
	timer.timeout.connect(_on_timeout)
	player.game_started.connect(_on_game_started)


func _on_game_started() -> void:
	if started:
		return
	started = true
	_spawn_barrel()


func _on_timeout() -> void:
	_spawn_barrel()


func _spawn_barrel() -> void:
	timer.setup()
	var barrel := BARREL.instantiate() as Barrel
	barrel.speed = barrel_speed
	add_child(barrel)
