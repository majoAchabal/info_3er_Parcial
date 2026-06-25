extends CanvasLayer

const FLASH_COLOR := Color(1, 0.847059, 0.145098, 1)
const WHITE := Color.WHITE
const FLASH_INTERVAL := 0.25

@onready var level_label: Label = $Control/VBoxContainer/LevelLabel
@onready var ready_label: Label = $Control/VBoxContainer/ReadyLabel

var flash_elapsed := 0.0
var use_white := false


func _ready() -> void:
	get_tree().paused = true
	process_mode = Node.PROCESS_MODE_ALWAYS
	
	level_label.text = "LEVEL %d" % LevelManager.current_level
	_set_flash_color(FLASH_COLOR)
	
	await get_tree().create_timer(1.5).timeout
	
	get_tree().paused = false
	queue_free()


func _process(delta: float) -> void:
	flash_elapsed += delta
	if flash_elapsed < FLASH_INTERVAL:
		return

	flash_elapsed = 0.0
	use_white = not use_white
	_set_flash_color(WHITE if use_white else FLASH_COLOR)


func _set_flash_color(color: Color) -> void:
	level_label.add_theme_color_override("font_color", color)
	ready_label.add_theme_color_override("font_color", color)
