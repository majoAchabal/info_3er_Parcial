extends Node2D

const BARREL := preload("res://Scenes/barrel.tscn")

@onready var timer: SpawnTimer = $SpawnTimer


func _ready() -> void:
	timer.timeout.connect(_on_timeout)


func _on_timeout() -> void:
	timer.setup()
	add_child(BARREL.instantiate())
