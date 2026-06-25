extends CanvasLayer

class_name UI

@onready var score_label: Label = $MarginContainer/HBoxContainer/Score
@onready var lives_label: Label = $MarginContainer/HBoxContainer/Lives
@onready var win_label: Label = $MarginContainer/HBoxContainer/WinLabel
@onready var lose_container: Container = $MarginContainer/CenterContainer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_hud()


func update_hud() -> void:
	score_label.text = "Points: %d" % GameState.score
	lives_label.text = "Lives: %d" % GameState.lives


func set_points(points: int) -> void:
	GameState.add_score(points)
	update_hud()


func show_lose_ui() -> void:
	update_hud()
	lose_container.show()


func show_win_ui() -> void:
	win_label.show()
	get_tree().paused = true


func _on_restart_button_pressed() -> void:
	get_tree().paused = false
	LevelManager.start_game()
