extends Control

func _ready() -> void:
	SoundManager.stop_music()

func _on_retry_button_pressed() -> void:
	LevelManager.start_game()

func _on_menu_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
