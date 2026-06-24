extends Node

class_name PointsManager

const LABEL_SCENE  := preload("res://Scenes/points_label.tscn")
const LABEL_OFFSET := Vector2(0, -25)

@export var value_per_barrel := 100

@onready var player: Player = $"../Player"
@onready var ui:     UI     = $"../UI"

var score := 0


func _ready() -> void:
	player.award_points.connect(_on_barrel_cleared)


func _on_barrel_cleared(pos: Vector2) -> void:
	score += value_per_barrel
	ui.set_points(score)
	_spawn_label(pos)


func _spawn_label(pos: Vector2) -> void:
	var label  := LABEL_SCENE.instantiate() as Label
	label.text  = str(value_per_barrel)
	label.position = pos + LABEL_OFFSET
	add_child(label)
