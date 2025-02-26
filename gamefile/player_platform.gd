extends CharacterBody2D

var speed = 200
var rotation_speed = 2

func _physics_process(delta):
	velocity = Vector2.ZERO
	
	if Input.is_action_pressed("ui_right"):
		velocity.x += 1
	if Input.is_action_pressed("ui_left"):
		velocity.x -= 1
	if Input.is_action_pressed("ui_down"):
		velocity.y += 1
	if Input.is_action_pressed("ui_up"):
		velocity.y -= 1
	
	velocity = velocity.normalized() * speed
	move_and_slide()
	
	if Input.is_action_pressed("rotate_right"):
		rotation += rotation_speed * delta
	if Input.is_action_pressed("rotate_left"):
		rotation -= rotation_speed * delta
	
	for body in get_tree().get_nodes_in_group("rigid_bodies"):
		if body is RigidBody2D:
			body.apply_impulse(Vector2.ZERO, velocity * 10)
