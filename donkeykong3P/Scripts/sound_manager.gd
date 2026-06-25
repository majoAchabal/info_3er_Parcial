extends Node

var jump_sound = preload("res://Assets/Sounds/jump.wav")
var death_sound = preload("res://Assets/Sounds/death.wav")
var hammer_sound = preload("res://Assets/Sounds/hammer_loop.wav")
var item_sound = preload("res://Assets/Sounds/itemget.wav")
var win_sound = preload("res://Assets/Sounds/win1.wav")
var menu_music = preload("res://Assets/Sounds/intro1_long.wav")
var level_music = preload("res://Assets/Sounds/bacmusic.wav")
var point_sound = preload("res://Assets/Sounds/point.wav")
var hammer_hit_sound = preload("res://Assets/Sounds/hammerhit.wav")
var fall_sound = preload("res://Assets/Sounds/fall.wav")


var hammer_player := AudioStreamPlayer.new()
var hammer_loop_active := false
var music_player := AudioStreamPlayer.new()
var current_music: AudioStream = null
var sfx_players: Array[AudioStreamPlayer] = []


func _ready():
	add_child(hammer_player)
	hammer_player.stream = hammer_sound
	hammer_player.finished.connect(_on_hammer_finished)
	add_child(music_player)
	music_player.volume_db = -10
	music_player.finished.connect(_on_music_finished)


func play(sound: AudioStream) -> void:
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	sfx_players.append(audio)
	audio.stream = sound
	audio.play()
	audio.finished.connect(func():
		sfx_players.erase(audio)
		audio.queue_free()
	)


func play_jump():
	play(jump_sound)


func play_death():
	play(death_sound)


func play_hammer():
	play(hammer_sound)


func play_item():
	play(item_sound)


func play_win():
	play(win_sound)



func start_hammer_loop():
	hammer_loop_active = true
	
	if not hammer_player.playing:
		hammer_player.play()


func stop_hammer_loop():
	hammer_loop_active = false
	hammer_player.stop()


func _on_hammer_finished():
	if hammer_loop_active:
		hammer_player.play()
		
func play_menu_music():
	current_music = menu_music
	
	if music_player.stream != menu_music:
		music_player.stream = menu_music
	
	if not music_player.playing:
		music_player.play()


func play_level_music():
	current_music = level_music
	
	if music_player.stream != level_music:
		music_player.stream = level_music
	
	if not music_player.playing:
		music_player.play()
		
func _on_music_finished():
	if current_music != null:
		music_player.play()


func stop_music():
	music_player.stop()
	
func stop_all_sfx() -> void:
	for audio in sfx_players:
		if is_instance_valid(audio):
			audio.stop()
			audio.queue_free()
	sfx_players.clear()
	stop_hammer_loop()
	
func play_point():
	play(point_sound)

func play_hammer_hit():
	play(hammer_hit_sound)

func play_fall():
	play(fall_sound)
