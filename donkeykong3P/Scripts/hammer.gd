extends Area2D


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body.pick_up_hammer()
		queue_free()
