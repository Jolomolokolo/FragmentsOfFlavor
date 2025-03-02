extends Node2D

signal customer_spawn

@export var customer_scene: PackedScene

@export var timer_range_start: int = 5
@export var timer_range_end: int = 10

var rng = RandomNumberGenerator.new()
var tables = []
var group_size


func _ready() -> void:
	for child in get_children():
		if child is StaticBody2D:
			tables.append({
				"node": child,
				"position": child.global_position,
				"capacity": child.capacity,
				"drc_n": child.direction_n,
				"drc_o": child.direction_o,
				"drc_s": child.direction_s,
				"drc_w": child.direction_w
			})
	tables.shuffle()
	#print(tables)

func _on_tutorial_finisher_body_entered(_body: CharacterBody2D) -> void:
	$Timer.start(3)
	print("Tutorial Finish")
	
func _on_timer_timeout() -> void:
	print("Timeout -> Start")
	customer_spawn.emit()

func _on_customer_spawn():
	if Global.cafe_area == true:
		tables.shuffle()
		for table in tables:
			if not table["node"].occupied:
				var seats = get_seat_positions(table)
				table["node"].occupied = true
				group_size = table["capacity"]
				#print("Table: ", table)
				#print("Seats: ", seats)
				
				for i in range(group_size):
					var customer = customer_scene.instantiate() as Customer
					customer.position = seats[i]
					add_child(customer)
				
				_on_restart()
				return
					#customer.make_path(seats[i])
		print("All tables occupied")
		_on_restart()

func _on_restart() -> void:
	if $Timer.is_stopped():
		var random_time = round(rng.randf_range(timer_range_start, timer_range_end))
		$Timer.start(random_time)
		print("Restart: ", random_time)

func get_seat_positions(table) -> Array:
	var seat_positions = []
	var seat_distance = 32
	
	if table.get("drc_n", false):
		seat_positions.append(table["position"] + Vector2(0, -seat_distance))
	if table.get("drc_o", false):
		seat_positions.append(table["position"] + Vector2(seat_distance, 0))
	if table.get("drc_s", false):
		seat_positions.append(table["position"] + Vector2(0, seat_distance))
	if table.get("drc_w", false):
		seat_positions.append(table["position"] + Vector2(-seat_distance, 0))

	return seat_positions
