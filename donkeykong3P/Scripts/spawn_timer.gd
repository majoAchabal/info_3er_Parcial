extends Timer

class_name SpawnTimer

@export var min_interval := 2.0
@export var max_interval := 5.0


func _ready() -> void:
	setup()


func setup() -> void:
	wait_time = randf_range(min_interval, max_interval)
	start()
