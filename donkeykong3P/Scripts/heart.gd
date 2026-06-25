extends Node2D

const HEART_1 := preload("res://Assets/heart.png")
const HEART_2 := preload("res://Assets/heart2.png")
const FLOAT_SPEED := 12.0
const FRAME_TIME := 0.18

@onready var sprite: Sprite2D = $Sprite2D

var elapsed := 0.0
var frame_elapsed := 0.0
var frame := 0


func _ready() -> void:
	sprite.texture = HEART_1


func _process(delta: float) -> void:
	elapsed += delta
	frame_elapsed += delta
	position.y -= FLOAT_SPEED * delta
	modulate.a = max(0.0, 1.0 - elapsed * 0.45)

	if frame_elapsed >= FRAME_TIME:
		frame_elapsed = 0.0
		frame = 1 - frame
		sprite.texture = HEART_1 if frame == 0 else HEART_2

	if modulate.a <= 0.0:
		queue_free()
