extends Control

const KONG_HAPPY_1 := preload("res://Assets/Kong_Happy1.png")
const KONG_HAPPY_2 := preload("res://Assets/Kong_Happy2.png")
const KONG_FRAME_TIME := 0.25

@onready var kong: TextureRect = $CenterContainer/MenuStack/Kong

var elapsed := 0.0
var frame := 0


func _ready() -> void:
	SoundManager.stop_music()


func _process(delta: float) -> void:
	elapsed += delta
	if elapsed < KONG_FRAME_TIME:
		return

	elapsed = 0.0
	frame = 1 - frame
	kong.texture = KONG_HAPPY_1 if frame == 0 else KONG_HAPPY_2


func _on_retry_button_pressed() -> void:
	LevelManager.start_game()


func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")