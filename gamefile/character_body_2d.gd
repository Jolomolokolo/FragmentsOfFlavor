extends CharacterBody2D

@export var speed: float = 250.0

func _physics_process(delta):
	var direction = Vector2.ZERO
	
	if Input.is_action_pressed("ui_left"):
		direction.x -= 1
	if Input.is_action_pressed("ui_right"):
		direction.x += 1
	if Input.is_action_pressed("ui_up"):
		direction.y -= 1
	if Input.is_action_pressed("ui_down"):
		direction.y += 1
	
	if direction != Vector2.ZERO:
		direction = direction.normalized()
	velocity = direction * speed
	
	move_and_collide(velocity * delta)
