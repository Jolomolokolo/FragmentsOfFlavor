extends Node2D
signal tutorial_finished

var rng = RandomNumberGenerator.new()

func _ready() -> void:
	pass

func _process(delta: float) -> void:
	pass

func _on_area_2d_body_entered(body: Node2D):
	tutorial_finished.emit()

func _on_tutorial_finished() -> void:
	var random_time = round(rng.randf_range(10, 25))
	$Timer.start(random_time)
	
	print("Tutorial finished: ", random_time)

func _on_timer_timeout() -> void:
	print("Timeout")
