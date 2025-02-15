extends CharacterBody2D

@onready var cam = $CameraFireMinigame

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
	
	#print(self.position)
	if self.position.y > 800:
		self.position = Vector2(32,672)
	
	if self.position.x > 1800:
		print("FINISH")
