extends Node2D

func _process(delta):
	position.y -= 20 * delta
	modulate.a -= delta

	if modulate.a <= 0:
		queue_free()
