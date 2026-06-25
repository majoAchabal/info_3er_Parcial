extends Control

const KONG_JUMP_HEIGHT := 18.0
const KONG_JUMP_SPEED := 7.0

@onready var kong: TextureRect = $CenterContainer/MenuStack/Kong

var kong_start_y := 0.0
var elapsed := 0.0


func _ready() -> void:
	SoundManager.stop_all_sfx()
	SoundManager.play_menu_music()
	await get_tree().process_frame
	kong_start_y = kong.position.y + 32.0


func _process(delta: float) -> void:
	elapsed += delta
	kong.position.y = kong_start_y - abs(sin(elapsed * KONG_JUMP_SPEED)) * KONG_JUMP_HEIGHT


func _on_start_button_pressed() -> void:
	LevelManager.start_game()


func _on_quit_button_pressed() -> void:
	get_tree().quit()