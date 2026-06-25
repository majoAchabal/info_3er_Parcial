extends Control

func _ready() -> void:
	SoundManager.stop_all_sfx()
	SoundManager.play_menu_music()

func _on_start_button_pressed() -> void:
	LevelManager.start_game()

func _on_quit_button_pressed() -> void:
	get_tree().quit()
