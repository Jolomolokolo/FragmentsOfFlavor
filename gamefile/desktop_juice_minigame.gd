extends Node2D

@export var object_scene: PackedScene

@export var spawn_x_min: float = -300.0
@export var spawn_x_max: float = 300.0

@export var spawn_y_min: float = -500.0
@export var spawn_y_max: float = -100.0

@export var spawn_rate: float = 0.2

var spawn_timer: Timer

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.wait_time = 1.0 / spawn_rate
	spawn_timer.one_shot = false
	spawn_timer.autostart = true
	add_child(spawn_timer)
	
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)

func _on_spawn_timer_timeout():
	spawn_object()

func spawn_object():
	
	var spawn_x = randf_range(spawn_x_min, spawn_x_max)
	
	var spawn_y = randf_range(spawn_y_min, spawn_y_max)
	
	var new_object = object_scene.instantiate()
	
	new_object.position = Vector2(spawn_x, spawn_y)
	
	add_child(new_object)
