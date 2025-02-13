extends CharacterBody2D

@export var speed: float = 200.0
@export var jump_force: float = 300.0
@export var gravity: float = 1200.0

func _physics_process(delta: float) -> void:
	if not is_on_floor():
		velocity.y += gravity * delta
	
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * speed
	else:
		velocity.x = move_toward(velocity.x, 0, speed)
	
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = -jump_force
	
	move_and_slide()


func _on_area_2d_body_entered(body) -> void:
	if body.is_in_group("player"):
		body.position = Vector2(32, 670)
