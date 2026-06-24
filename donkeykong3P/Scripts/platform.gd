extends RigidBody2D

class_name Platform

@export var can_be_disabled := false

@onready var collision: CollisionShape2D = $CollisionShape2D


func disable_collision() -> void:
	if can_be_disabled:
		collision.disabled = true


func enable_collision() -> void:
	if can_be_disabled:
		collision.disabled = false
