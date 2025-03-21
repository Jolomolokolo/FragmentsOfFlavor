extends CharacterBody2D

@export var speed: float = 250.0
@export var sprint_multiplier: float = 2.0
@export var cooldown: float = 1.0
var sprint_enabled = true

func _physics_process(delta):
	if Global.cafe_area == true:
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
		
		if Input.is_action_pressed("ui_accept"):
			if sprint_enabled:
				velocity = direction * speed * sprint_multiplier
				sprint_enabled = false
				$Timer.start(cooldown)
		else:
			velocity = direction * speed

		move_and_collide(velocity * delta)

func _on_timer_timeout() -> void:
	sprint_enabled = true
