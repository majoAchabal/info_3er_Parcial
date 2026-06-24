extends Area2D

@export var ui: UI


func _on_body_entered(body: Node) -> void:
	if body is Player:
		ui.show_win_ui()
