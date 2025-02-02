extends Node2D
signal tutorial_finished
signal customer_spawn(group_size: int)

var rng = RandomNumberGenerator.new()
@export var customer_scene: PackedScene

func _on_area_2d_body_entered(_body: Node2D):
	tutorial_finished.emit()

func _on_tutorial_finished() -> void:
	var random_time = round(rng.randf_range(10, 25))
	$Timer.start(random_time)
	print("Tutorial finished: ", random_time)

func _on_timer_timeout() -> void:
	var group_size = round(rng.randf_range(1,4))
	print(group_size)
	customer_spawn.emit(group_size)

func _on_tables_customer_spawn_w_size(group_size: int):
	var x_offset = 0
	for group in group_size:
		var customer = customer_scene.instantiate() as CharacterBody2D
		customer.position.x += x_offset
		add_child(customer)
		x_offset += 5
	print("Timeout")
