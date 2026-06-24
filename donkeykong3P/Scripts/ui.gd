extends CanvasLayer

class_name UI

@onready var score_label:    Label     = $MarginContainer/HBoxContainer/Score
@onready var win_label:      Label     = $MarginContainer/HBoxContainer/WinLabel
@onready var lose_container: Container = $MarginContainer/CenterContainer


func set_points(points: int) -> void:
	score_label.text = "Points: %d" % points


func show_lose_ui() -> void:
	lose_container.show()


func show_win_ui() -> void:
	win_label.show()


func _on_restart_button_pressed() -> void:
	get_tree().reload_current_scene()
