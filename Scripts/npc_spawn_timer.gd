extends Timer

var current_wait_time : float

func _ready() -> void:
	current_wait_time = wait_time

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if time_left > 0:
		current_wait_time -= 0.01 * delta
		var new_time = current_wait_time + randf_range(0, 3)
		wait_time = clamp(new_time, 0.1, 10)
		print("wait_time; ", wait_time)
