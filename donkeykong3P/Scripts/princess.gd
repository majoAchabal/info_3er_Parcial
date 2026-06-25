extends Area2D

const HEART = preload("res://Scenes/heart.tscn")
const PRINCESS_1 = preload("res://Assets/Princess.png")
const PRINCESS_2 = preload("res://Assets/Princess2.png")
const HELP_TEXTURE = preload("res://Assets/Help.png")
const PRINCESS_FRAME_TIME := 0.45
const HELP_INTERVAL := 2.4
const HELP_VISIBLE_TIME := 0.8

@onready var sprite: Sprite2D = $Sprite2D
@onready var help_sprite: Sprite2D = $HelpSprite

var triggered := false
var princess_elapsed := 0.0
var princess_frame := 0
var help_elapsed := 0.0


func _ready() -> void:
	help_sprite.texture = HELP_TEXTURE


func _process(delta: float) -> void:
	_update_princess_animation(delta)
	_update_help_bubble(delta)


func _update_princess_animation(delta: float) -> void:
	princess_elapsed += delta
	if princess_elapsed < PRINCESS_FRAME_TIME:
		return

	princess_elapsed = 0.0
	princess_frame = 1 - princess_frame
	sprite.texture = PRINCESS_1 if princess_frame == 0 else PRINCESS_2


func _update_help_bubble(delta: float) -> void:
	help_elapsed = fmod(help_elapsed + delta, HELP_INTERVAL)
	help_sprite.visible = help_elapsed < HELP_VISIBLE_TIME and not triggered


func _on_body_entered(body: Node) -> void:
	if triggered:
		return

	if body is Player:
		triggered = true
		help_sprite.hide()

		var heart = HEART.instantiate()
		get_parent().add_child(heart)
		heart.global_position = global_position + Vector2(0, -20)

		SoundManager.play_win()

		await get_tree().create_timer(5.0).timeout
		SoundManager.stop_all_sfx()
		LevelManager.next_level()
