extends Area2D

@export var respawn_time := 20.0

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D
var collected := false


func _on_body_entered(body: Node) -> void:
	if collected:
		return

	if body is Player:
		collected = true
		
		body.pick_up_hammer()

		sprite.visible = false
		collision.set_deferred("disabled", true)

		await get_tree().create_timer(respawn_time).timeout

		sprite.visible = true
		collision.set_deferred("disabled", false)

		collected = false
