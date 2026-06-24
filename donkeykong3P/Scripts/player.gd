extends CharacterBody2D

class_name Player

signal award_points(position: Vector2)
signal game_started

const SPEED          := 300.0
const JUMP_VELOCITY  := -400.0
const HAMMER_PIVOT   := Vector2(0, -3)
const FALL_LIMIT_Y   := 495.0
const FALL_DEATH_REENTRY_Y := 440.0
const FALL_DEATH_JUMP_VELOCITY := -450.0

@export var climb_speed := 250.0
@export var ui: UI

@onready var sprite:       AnimatedSprite2D = $AnimatedSprite2D
@onready var collision:    CollisionShape2D = $CollisionShape2D
@onready var raycast:      RayCast2D        = $RayCast2D
@onready var hammer_node:  Node2D           = $Hammer
@onready var hammer_area:  Area2D           = $HammerCollision
@onready var hammer_timer: Timer            = $Timer

var facing         := 1
var ladder_x       := 0.0
var can_climb      := false
var on_ladder      := false
var platform_below: Platform = null
var last_barrel_id             = null
var has_hammer     := false
var hammer_origin: Vector2
var dead           := false
var death_motion   := false
var has_started_game := false

var gravity: float = ProjectSettings.get_setting("physics/2d/default_gravity")


func _ready() -> void:
	hammer_origin = hammer_node.position
	hammer_timer.timeout.connect(_on_hammer_expired)
	sprite.frame_changed.connect(_on_frame_changed)


func _physics_process(delta: float) -> void:
	if dead:
		if death_motion:
			velocity.y += gravity * delta
			move_and_slide()
		return
	_check_game_start()
	_apply_gravity(delta)
	_handle_jump()
	_handle_horizontal()
	_update_animation()
	move_and_slide()
	_handle_collisions()
	_handle_climbing(delta)
	_check_barrel_jump()
	_check_fall_limit()

func _check_game_start() -> void:
	if has_started_game:
		return
	if Input.is_action_pressed("left") or Input.is_action_pressed("right") or Input.is_action_pressed("up") or Input.is_action_pressed("down") or Input.is_action_just_pressed("jump"):
		has_started_game = true
		game_started.emit()

func _apply_gravity(delta: float) -> void:
	if not is_on_floor() and not on_ladder:
		velocity.y += gravity * delta


func _handle_jump() -> void:
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y    = JUMP_VELOCITY
		last_barrel_id = null
		SoundManager.play_jump()


func _handle_horizontal() -> void:
	var dir := Input.get_axis("left", "right")
	if dir != 0.0 and not on_ladder:
		velocity.x = dir * SPEED
		facing     = sign(dir)
		hammer_area.position.x = 10.0 * sign(dir)
		sprite.flip_h = dir < 0
	else:
		velocity.x = move_toward(velocity.x, 0.0, SPEED)


func _handle_collisions() -> void:
	var col := get_last_slide_collision() as KinematicCollision2D
	if not col:
		return

	var body := col.get_collider()

	if body is Platform:
		if roundf(rad_to_deg(col.get_angle())) == 90.0:
			position.y -= 8.0

	if body is Barrel and not dead:
		_die()


func _handle_climbing(delta: float) -> void:
	if not can_climb:
		return

	var dir := Input.get_axis("down", "up")

	if dir != 0.0:
		on_ladder  = true
		position.x = ladder_x
		sprite.play("climb")

	_manage_platform_passthrough(dir)
	position.y -= dir * climb_speed * delta

	if on_ladder and is_on_floor():
		on_ladder = false


func _manage_platform_passthrough(dir: float) -> void:
	if dir == -1.0:
		var col := get_last_slide_collision() as KinematicCollision2D
		if col and col.get_collider() is Platform:
			var p := col.get_collider() as Platform
			if p.can_be_disabled and platform_below == null:
				platform_below = p
				platform_below.disable_collision()

	if dir == 1.0 and platform_below:
		platform_below.enable_collision()
		platform_below = null


func _check_barrel_jump() -> void:
	if is_on_floor():
		return
	var body := raycast.get_collider()
	if body is Barrel and last_barrel_id == null:
		last_barrel_id = body.get_rid()
		award_points.emit(body.global_position)

func _check_fall_limit() -> void:
	if position.y > FALL_LIMIT_Y:
		_die(true)

func _update_animation() -> void:
	if velocity.x != 0.0:
		sprite.play("run_hammer" if has_hammer else "run")
	elif not on_ladder:
		sprite.play("idle_hammer" if has_hammer else "idle")


func enable_climbing(x: float) -> void:
	ladder_x  = x
	can_climb = true


func disable_climbing() -> void:
	can_climb = false
	on_ladder = false


func pick_up_hammer() -> void:
	has_hammer             = true
	hammer_node.visible    = true
	hammer_area.monitoring = true
	hammer_timer.start()
	SoundManager.play_item()
	SoundManager.start_hammer_loop()


func _on_hammer_expired() -> void:
	has_hammer             = false
	hammer_node.visible    = false
	hammer_area.monitoring = false
	SoundManager.stop_hammer_loop()


func _on_frame_changed() -> void:
	if not has_hammer or on_ladder:
		return
	var angle            := _hammer_angle(sprite.frame)
	hammer_node.position  = HAMMER_PIVOT + (hammer_origin - HAMMER_PIVOT).rotated(angle)
	hammer_node.rotation  = angle


func _hammer_angle(frame: int) -> float:
	var base := deg_to_rad(90.0 * sign(facing))
	match sprite.animation:
		"idle_hammer": return base if frame == 0 else 0.0
		"run_hammer":  return base if frame in [1, 3] else 0.0
	return 0.0


func _die(from_fall := false) -> void:
	if dead:
		return
	dead = true
	SoundManager.stop_hammer_loop()
	SoundManager.play_death()
	death_motion = from_fall
	set_collision_layer_value(1, false)
	if from_fall:
		position.y = min(position.y, FALL_DEATH_REENTRY_Y)
		velocity = Vector2(0, FALL_DEATH_JUMP_VELOCITY)
	else:
		gravity = 0.0
		velocity = Vector2.ZERO
	sprite.play("die")


func _on_hammer_collision_body_entered(body: Node) -> void:
	if body is Barrel:
		award_points.emit(body.global_position)
		body.queue_free()


func _on_animated_sprite_2d_animation_finished() -> void:
	if sprite.animation == "die":
		ui.show_lose_ui()
