extends CanvasLayer

@onready var level_label: Label = $Control/VBoxContainer/LevelLabel

func _ready() -> void:
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	level_label.text = "LEVEL %d" % LevelManager.current_level
	
	await get_tree().create_timer(1.5).timeout
	
	get_tree().paused = false
	queue_free()
