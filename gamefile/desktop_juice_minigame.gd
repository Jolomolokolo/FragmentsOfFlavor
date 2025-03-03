extends Node2D

@export var object_scene: PackedScene

@export var spawn_x_min: float = -300
@export var spawn_x_max: float = 300

@export var spawn_y_min: float = -900
@export var spawn_y_max: float = -650

@export var spawn_rate_min: float = 1.0
@export var spawn_rate_max: float = 4.5

var spawn_timer: Timer
var is_spawning: bool = false

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = randf_range(spawn_rate_min, spawn_rate_max)

func _process(_delta):
	if Global.desktop_juice_visible and not is_spawning:
		start_spawning()
	elif not Global.desktop_juice_visible and is_spawning:
		stop_spawning()

func start_spawning():
	is_spawning = true
	set_random_spawn_time()

func stop_spawning():
	is_spawning = false
	spawn_timer.stop()

func _on_spawn_timer_timeout():
	if is_spawning:
		spawn_object()
		set_random_spawn_time()

func spawn_object():
	var spawn_x = randf_range(spawn_x_min, spawn_x_max)
	var spawn_y = randf_range(spawn_y_min, spawn_y_max)
	var new_object = object_scene.instantiate()
	new_object.position = Vector2(spawn_x, spawn_y)
	#print("Spawning at:", spawn_x, spawn_y)
	#print(new_object.position)
	add_child(new_object)

func set_random_spawn_time():
	spawn_timer.wait_time = randf_range(spawn_rate_min, spawn_rate_max)
	spawn_timer.start()
