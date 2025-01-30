extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var time = 10
	$Timer.start(time)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_timer_timeout() -> void:
	$Table.duplicate()
