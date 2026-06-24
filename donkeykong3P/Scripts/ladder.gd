extends Area2D

const TILE_PX := 8.0

@export var length: float = 2.0
@export var top_clearance: float = 6.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _ready() -> void:
	_build_shape()
	_build_sprite()


func _build_shape() -> void:
	var shape := RectangleShape2D.new()
	shape.size = Vector2(0.025, length * TILE_PX + top_clearance)
	collision.shape = shape
	collision.position.y = -top_clearance


func _build_sprite() -> void:
	sprite.region_rect = Rect2(0, TILE_PX * length, TILE_PX, TILE_PX * length)


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.enable_climbing(position.x)


func _on_body_exited(body: Node) -> void:
	if body is Player:
		body.disable_climbing()