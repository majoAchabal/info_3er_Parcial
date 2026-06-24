extends Node2D

const BARREL := preload("res://Scenes/barrel.tscn")

@onready var timer: SpawnTimer = $SpawnTimer
@onready var player: Player = $"../Player"

var started := false


func _ready() -> void:
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
	add_child(BARREL.instantiate())
