extends CanvasLayer

func _ready() -> void:
	hide()


func _unhandled_input(event):
	if event.is_action_pressed("ui_cancel"):
		toggle_pause()


func toggle_pause():
	var paused := !get_tree().paused
	
	get_tree().paused = paused
	visible = paused

	SoundManager.music_player.stream_paused = paused
	SoundManager.hammer_player.stream_paused = paused


func _on_resume_button_pressed() -> void:
	toggle_pause()


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	
	SoundManager.music_player.stream_paused = false
	SoundManager.hammer_player.stream_paused = false
	
	LevelManager.restart_level()


func _on_menu_button_pressed() -> void:
	get_tree().paused = false
	
	SoundManager.music_player.stream_paused = false
	SoundManager.hammer_player.stream_paused = false
	
	get_tree().change_scene_to_file("res://Scenes/main_menu.tscn")
