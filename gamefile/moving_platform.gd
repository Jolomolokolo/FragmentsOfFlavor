extends AnimatableBody2D

@export var target_position: Vector2 = Vector2(200, 0)
@export var speed: float = 100.0

var start_position: Vector2
var direction: int = 1

func _ready():
	start_position = global_position

func _process(delta):
	var move_vector = target_position * direction
	var step = speed * delta
	global_position = global_position.move_toward(start_position + move_vector, step)
	
	if global_position.is_equal_approx(start_position + move_vector):
		direction *= -1
