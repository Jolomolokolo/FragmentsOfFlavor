extends CharacterBody2D

@export var speed: float = 100.0
@export var move_distance: float = 200.0

var direction: int = 1
var start_position: Vector2

func _ready():
	start_position = global_position

func _physics_process(delta: float):
	var movement = Vector2.RIGHT * direction * speed * delta
	global_position += movement
	
	if abs(global_position.x - start_position.x) >= move_distance:
		direction *= -1
