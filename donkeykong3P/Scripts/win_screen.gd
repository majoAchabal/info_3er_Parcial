extends Control

const PRINCESS_FRAME_1 := preload("res://Assets/Princess.png")
const PRINCESS_FRAME_2 := preload("res://Assets/Princess2.png")
const HEART_FRAME_1 := preload("res://Assets/heart.png")
const HEART_FRAME_2 := preload("res://Assets/heart2.png")

@onready var princess: TextureRect = $CenterContainer/WinStack/CharacterStage/Princess
@onready var heart: TextureRect = $CenterContainer/WinStack/CharacterStage/Heart
@onready var mario: TextureRect = $CenterContainer/WinStack/CharacterStage/Mario

var frame_index := 0


func _ready() -> void:
	SoundManager.stop_music()
	SoundManager.play_win()
	_update_victory_animation()


func _on_animation_timer_timeout() -> void:
	frame_index = 1 - frame_index
	_update_victory_animation()


func _update_victory_animation() -> void:
	var use_first_frame := frame_index == 0
	princess.texture = PRINCESS_FRAME_1 if use_first_frame else PRINCESS_FRAME_2
	heart.texture = HEART_FRAME_1 if use_first_frame else HEART_FRAME_2
	mario.flip_h = not use_first_frame


func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
