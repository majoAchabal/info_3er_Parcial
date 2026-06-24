extends CharacterBody2D

class_name Player

signal award_points(position: Vector2)

const SPEED := 300.0
const JUMP_VELOCITY := -400.0

@export var climb_speed := 250.0
@export var ui: UI

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var raycast: RayCast2D = $RayCast2D

var ladder_x := 0.0
var can_climb := false
var on_ladder := false
var last_barrel_id = null
var dead := false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _physics_process(delta: float) -> void:
	if dead:
		return
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal()
	_update_animation()
	move_and_slide()
	_handle_collisions()
	_handle_climbing(delta)
	_check_barrel_jump()


func _apply_gravity(delta: float) -> void:
	if not is_on_floor() and not on_ladder:
		velocity.y += gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		last_barrel_id = null


func _handle_horizontal() -> void:
	var dir := Input.get_axis("left", "right")
	if dir != 0.0 and not on_ladder:
		velocity.x = dir * SPEED
		sprite.flip_h = dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)


func _handle_collisions() -> void:
	var col := get_last_slide_collision() as KinematicCollision2D
	if not col:
		return

	var body := col.get_collider()
	if body is Barrel and not dead:
		_die()


func _handle_climbing(delta: float) -> void:
	if not can_climb:
		return

	var dir := Input.get_axis("down", "up")
	if dir != 0.0:
		on_ladder = true
		position.x = ladder_x
		sprite.play("climb")
		position.y -= dir * climb_speed * delta

	if on_ladder and is_on_floor():
		on_ladder = false


func _check_barrel_jump() -> void:
	if is_on_floor():
		return
	var body := raycast.get_collider()
	if body is Barrel and last_barrel_id == null:
		last_barrel_id = body.get_rid()
		award_points.emit(body.global_position)


func _update_animation() -> void:
	if velocity.x != 0.0:
		sprite.play("run")
	elif not on_ladder:
		sprite.play("idle")


func enable_climbing(x: float) -> void:
	ladder_x = x
	can_climb = true


func disable_climbing() -> void:
	can_climb = false
	on_ladder = false


func _die() -> void:
	dead = true
	gravity = 0.0
	set_collision_layer_value(1, false)
	sprite.play("die")


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "die":
		ui.show_lose_ui()