extends CharacterBody2D

@onready var cam = $CameraFireMinigame
@onready var finish_canvas = $"../Finish"

@export var speed: float = 200.0
@export var jump_force: float = 300.0
@export var gravity: float = 1200.0
@export var test = false

var platform_velocity = Vector2.ZERO
var start_time = 0.0
var is_playing = false

func _ready():
	finish_canvas.visible = false

func _physics_process(delta: float) -> void:
	if (Global.desktop_fire_visible and not Global.fire_minigame_finished) or test:
		if not is_playing:
			start_game()
		
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
			reset_position()
			Global.downfalls += 1
	
		if self.position.x > 3250 and not Global.fire_minigame_finished:
			finish_game()

func start_game():
	reset_position()
	Global.fire_minigame_finished = false
	Global.downfalls = 0
	start_time = Time.get_ticks_msec() / 1000.0
	is_playing = true
	finish_canvas.visible = false

func finish_game():
	finish_canvas.visible = true
	Global.fire_minigame_finished = true
	var end_time = Time.get_ticks_msec() / 1000.0
	var elapsed_time = end_time - start_time
	# Funktion for time comparison start here!
	print("Time elapsed: ", elapsed_time, " sec")

func reset_position():
	self.position = Vector2(32, 672)

func set_platform_velocity(vel: Vector2):
	platform_velocity = vel

func _on_finish_start_game() -> void:
	start_game()
