extends Control


func _ready() -> void:
	SoundManager.stop_music()
	SoundManager.play_win()
	

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
