extends Node

var current_level := 1

var levels := {
	1: "res://Scenes/level_1.tscn",
	2: "res://Scenes/level_2.tscn",
	3: "res://Scenes/level_3.tscn"
}

func start_game():
	GameState.reset_game()
	current_level = 1
	load_level(current_level)

func load_level(level_number: int):
	SoundManager.play_level_music()
	get_tree().call_deferred("change_scene_to_file", levels[level_number])
	

func next_level():
	current_level += 1
	
	if current_level > 3:
		get_tree().call_deferred("change_scene_to_file", "res://Scenes/win_screen.tscn")
	else:
		load_level(current_level)

func restart_level():
	load_level(current_level)
