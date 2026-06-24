extends RigidBody2D

class_name Barrel

const FALL_THRESHOLD    := 300.0
const LADDER_DROP_RANGE := 48.0
const BUMP              := Vector2(100.0, -200.0)

@export var speed := 200.0

var direction        :=  1
var can_flip         := true
var dropping         := false
var drop_origin_y    := 0.0


func _physics_process(_delta: float) -> void:
	if dropping:
		_process_drop()
		return
	_process_roll()


func _process_roll() -> void:
	if linear_velocity.y < 200.0:
		linear_velocity.x = speed * direction
	else:
		linear_velocity.x = 0.0

	if linear_velocity.y > FALL_THRESHOLD and can_flip:
		direction *= -1
		can_flip   = false
	elif not can_flip and linear_velocity.y < 0.1:
		can_flip = true
		apply_impulse(BUMP * Vector2(direction, 1.0))


func _process_drop() -> void:
	if position.y - drop_origin_y > LADDER_DROP_RANGE:
		dropping = false
		set_collision_mask_value(4, true)


func drop_down_ladder() -> void:
	if dropping:
		return
	dropping             = true
	drop_origin_y        = position.y
	linear_velocity.x    = 0.0
	set_collision_mask_value(4, false)
