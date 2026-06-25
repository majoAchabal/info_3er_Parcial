extends Area2D

const HEART = preload("res://Scenes/heart.tscn")

var triggered := false


func _on_body_entered(body: Node) -> void:
	if triggered:
		return

	if body is Player:
		triggered = true

		var heart = HEART.instantiate()
		get_parent().add_child(heart)
		heart.global_position = global_position + Vector2(0, -20)

		SoundManager.play_win()

		await get_tree().create_timer(5.0).timeout
		SoundManager.stop_all_sfx()
		LevelManager.next_level()
