extends Node

var score := 0
var lives := 3

func reset_game() -> void:
	score = 0
	lives = 3

func add_score(points: int) -> void:
	score += points

func lose_life() -> void:
	lives -= 1
