extends Node

var jump_sound = preload("res://Assets/Sounds/jump.wav")
var death_sound = preload("res://Assets/Sounds/death.wav")
var hammer_sound = preload("res://Assets/Sounds/hammer_loop.wav")
var item_sound = preload("res://Assets/Sounds/itemget.wav")
var win_sound = preload("res://Assets/Sounds/win1.wav")

var hammer_player := AudioStreamPlayer.new()
var hammer_loop_active := false


func _ready():
	add_child(hammer_player)
	hammer_player.stream = hammer_sound
	hammer_player.finished.connect(_on_hammer_finished)


func play(sound: AudioStream) -> void:
	var audio := AudioStreamPlayer.new()
	add_child(audio)
	audio.stream = sound
	audio.play()
	audio.finished.connect(audio.queue_free)


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
