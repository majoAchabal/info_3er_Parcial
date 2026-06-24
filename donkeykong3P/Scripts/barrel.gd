extends RigidBody2D

class_name Barrel

const FALL_THRESHOLD := 300.0
const BUMP := Vector2(100.0, -200.0)

@export var speed := 200.0

var direction := 1
var can_flip := true


func _physics_process(_delta: float) -> void:
	_process_roll()


func _process_roll() -> void:
	if linear_velocity.y < 200.0:
		linear_velocity.x = speed * direction
	else:
		linear_velocity.x = 0.0

	if linear_velocity.y > FALL_THRESHOLD and can_flip:
		direction *= -1
		can_flip = false
	elif not can_flip and linear_velocity.y < 0.1:
		can_flip = true
		apply_impulse(BUMP * Vector2(direction, 1.0))