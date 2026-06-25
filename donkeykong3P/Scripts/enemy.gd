extends Area2D

const LEFT_TEXTURE  = preload("res://Assets/Left_Fireball.png")
const RIGHT_TEXTURE = preload("res://Assets/Right_Fireball.png")
const BLUE_TEXTURE = preload("res://Assets//Blue_Fireball.png")
var vulnerable := false

@export var speed := 70.0
@export var left_limit := -80.0
@export var right_limit := 80.0

@onready var sprite: Sprite2D = $Sprite2D

var start_x := 0.0
var direction := 1


func _ready() -> void:
	start_x = global_position.x
	sprite.texture = RIGHT_TEXTURE
	body_entered.connect(_on_body_entered)


func _process(delta: float) -> void:
	position.x += speed * direction * delta

	if global_position.x > start_x + right_limit:
		_flip(-1)
	elif global_position.x < start_x + left_limit:
		_flip(1)


func _flip(new_direction: int) -> void:
	direction = new_direction
	
	if vulnerable:
		sprite.texture = BLUE_TEXTURE
	else:
		sprite.texture = RIGHT_TEXTURE if direction > 0 else LEFT_TEXTURE
	


func _on_body_entered(body: Node) -> void:
	if body is Player:
		body._die()
		
func set_vulnerable(value: bool) -> void:
	vulnerable = value

	if vulnerable:
		sprite.texture = BLUE_TEXTURE
	else:
		sprite.texture = RIGHT_TEXTURE if direction > 0 else LEFT_TEXTURE


func die() -> void:
	SoundManager.play_hammer_hit()
	queue_free()
