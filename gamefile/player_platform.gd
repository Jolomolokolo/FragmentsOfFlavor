extends CharacterBody2D

@export var speed: float = 300.0
@export var rotation_speed: float = 3.0

@export var test: bool = false
var moveable:bool = true

func _physics_process(delta):
	if Global.desktop_juice_visible == true and moveable == true or test == true:
		#print(global_position)
		var direction := Vector2.ZERO

		if Input.is_action_pressed("ui_right"):
			direction.x += 1
		if Input.is_action_pressed("ui_left"):
			direction.x -= 1
		if Input.is_action_pressed("ui_down"):
			direction.y += 1
		if Input.is_action_pressed("ui_up"):
			direction.y -= 1

		velocity = direction.normalized() * speed
		move_and_collide(velocity * delta)

		if Input.is_action_pressed("rotate_left"):
			rotation -= rotation_speed * delta
		if Input.is_action_pressed("rotate_right"):
			rotation += rotation_speed * delta

func _on_desktop_juice_minigame_dead_juice() -> void:
	moveable = false

func _on_finish_juice_restart_juice() -> void:
	moveable = true
	self.position = Vector2(648, 616)
	rotation = 0

func _on_finish_juice_desktop_return_from_juice() -> void:
	moveable = true
	self.position = Vector2(648, 616)
	rotation = 0
