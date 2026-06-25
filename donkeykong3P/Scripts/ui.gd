extends CanvasLayer

class_name UI

@onready var score_label: Label = $MarginContainer/HudRoot/ScoreBlock/Score
@onready var level_label: Label = $MarginContainer/HudRoot/Level
@onready var life_icons: Array[TextureRect] = [
	$MarginContainer/HudRoot/LivesContainer/Life1,
	$MarginContainer/HudRoot/LivesContainer/Life2,
	$MarginContainer/HudRoot/LivesContainer/Life3,
]
@onready var win_label: Label = $MarginContainer/HudRoot/WinLabel
@onready var lose_container: Container = $MarginContainer/CenterContainer


func _ready() -> void:
	process_mode = Node.PROCESS_MODE_ALWAYS
	update_hud()


func update_hud() -> void:
	score_label.text = "%06d" % GameState.score
	level_label.text = "L=%02d" % LevelManager.current_level

	for i in range(life_icons.size()):
		life_icons[i].visible = i < GameState.lives


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

