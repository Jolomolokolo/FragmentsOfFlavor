extends CharacterBody2D

#signal fire_minigame_finished

@onready var cam = $CameraFireMinigame
@onready var finish_canvas = $"../Finish"

@export var speed: float = 200.0
@export var jump_force: float = 300.0
@export var gravity: float = 1200.0
@export var test = false

var platform_velocity = Vector2.ZERO

func _physics_process(delta: float) -> void:
	if Global.desktop_fire_visible == true and Global.fire_minigame_finished == false or test == true:
		if not is_on_floor():
			velocity.y += gravity * delta
		
		var direction = Input.get_axis("ui_left", "ui_right")
		if direction:
			velocity.x = direction * speed
		else:
			velocity.x = move_toward(velocity.x, 0, speed)
	
		if Input.is_action_just_pressed("ui_accept") and is_on_floor():
			velocity.y = -jump_force
		
		velocity += platform_velocity  

		move_and_slide()
	
		platform_velocity = Vector2.ZERO
	
		if self.position.y > 800:
			self.position = Vector2(32, 672)
			Global.downfalls += 1
	
		if self.position.x > 3250 and Global.fire_minigame_finished == false:
			finish_canvas.visible = true
			Global.fire_minigame_finished = true
			#fire_minigame_finished.emit()

func set_platform_velocity(vel: Vector2):
	platform_velocity = vel
