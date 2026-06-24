extends CharacterBody2D

class_name Player

const SPEED := 300.0
const JUMP_VELOCITY := -400.0

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal()
	_update_animation()
	move_and_slide()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY


func _handle_horizontal() -> void:
	var dir := Input.get_axis("left", "right")
	if dir != 0.0:
		velocity.x = dir * SPEED
		sprite.flip_h = dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)


func _update_animation() -> void:
	if velocity.x != 0.0:
		sprite.play("run")
	else:
		sprite.play("idle")