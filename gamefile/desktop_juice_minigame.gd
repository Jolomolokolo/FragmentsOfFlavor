extends Node2D

signal desktop_return_from_juice
signal dead_juice

@export var object_scenes: Array[PackedScene]
@export var spawn_probabilities: Array[float]

@export var spawn_x_min: float = -400
@export var spawn_x_max: float = 400
@export var spawn_y_min: float = -900
@export var spawn_y_max: float = -650

@export var spawn_rate_min: float = 1.2
@export var spawn_rate_max: float = 4.0

var spawn_timer: Timer
var is_spawning: bool = false
@export var test: bool = false

var object_counts = {}
var score_juice: int = 0
@onready var score_label = $CanvasLayer/Score
var hearts: int = 3
@onready var finish_juice = $Finish
var game_over: bool = false
@onready var timer = $Timer
@export var time = 300

@onready var splash_particles = $JuicerArea/GPUParticles2D

var score_history = []
var difficulty_factor: float = 1.0

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = randf_range(spawn_rate_min, spawn_rate_max)
	splash_particles.emitting = false

func reset_game():
	game_over = false
	is_spawning = false
	spawn_timer.stop()

	score_juice = 0
	object_counts.clear()
	hearts = 3
	finish_juice.visible = false
	update_score_label()
	difficulty_factor = 1.0
	
	timer.start(time)

	$CanvasLayer/Heart1.visible = true
	$CanvasLayer/Heart1Off.visible = false
	$CanvasLayer/Heart2.visible = true
	$CanvasLayer/Heart2Off.visible = false
	$CanvasLayer/Heart3.visible = true
	$CanvasLayer/Heart3Off.visible = false

	for child in get_children():
		if child is RigidBody2D:
			child.queue_free()

	start_spawning()

func _process(_delta):
	if Global.desktop_juice_visible and not is_spawning and not game_over or test:
		reset_game()
	elif not Global.desktop_juice_visible and is_spawning:
		stop_spawning()

func start_spawning():
	is_spawning = true
	set_random_spawn_time()

func stop_spawning():
	is_spawning = false
	spawn_timer.stop()

func _on_spawn_timer_timeout():
	if is_spawning:
		spawn_object()
		increase_difficulty()
		set_random_spawn_time()

func spawn_object():
	if object_scenes.is_empty() or spawn_probabilities.size() != object_scenes.size():
		return

	var selected_scene = select_scene_by_probability()
	if not selected_scene:
		return

	var spawn_x
	var spawn_y = randf_range(spawn_y_min, spawn_y_max)

	var offset_x = 600

	var scene_path = selected_scene.resource_path if selected_scene.resource_path else ""
	if "bomb" in scene_path or "tnt" in scene_path:
		spawn_x = randf_range(spawn_x_min * 0.3, spawn_x_max * 0.3) + offset_x
	else:
		spawn_x = randf_range(spawn_x_min, spawn_x_max) + offset_x
		if randf() < 0.3:
			spawn_x = (spawn_x_min if randf() < 0.5 else spawn_x_max) + offset_x

	var new_object = selected_scene.instantiate()
	new_object.position = Vector2(spawn_x, spawn_y)
	add_child(new_object)


func select_scene_by_probability():
	var total_probability = spawn_probabilities.reduce(func(a, b): return a + b, 0.0)
	if total_probability <= 0:
		return null

	var rand_value = randf() * total_probability
	var cumulative = 0.0

	for i in range(object_scenes.size()):
		cumulative += spawn_probabilities[i]
		if rand_value <= cumulative:
			return object_scenes[i]
	return null

func set_random_spawn_time():
	var new_min = max(spawn_rate_min * (1.0 / (1.0 + difficulty_factor * 0.5)), 0.6)
	var new_max = max(spawn_rate_max * (1.0 / (1.0 + difficulty_factor * 0.5)), 1.8)
	spawn_timer.wait_time = randf_range(new_min, new_max)
	spawn_timer.start()

func increase_difficulty():
	difficulty_factor += 0.01

	var bomb_index = object_scenes.find("res://juicer_elements/juicer_element_bomb.tscn")
	var tnt_index = object_scenes.find("res://juicer_elements/juicer_element_tnt.tscn")
	
	if bomb_index >= 0:
		spawn_probabilities[bomb_index] = min(spawn_probabilities[bomb_index] + 0.02 * difficulty_factor, 0.3)
	if tnt_index >= 0:
		spawn_probabilities[tnt_index] = min(spawn_probabilities[tnt_index] + 0.02 * difficulty_factor, 0.3)

func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		var type = body.get_meta("juicer_element")
		
		if type:
			object_counts[type] = object_counts.get(type, 0) + 1
			calculate_score()
			score_juice = max(score_juice, 0)
			update_score_label()
			splash_particles.global_position = body.global_position
			splash_particles.emitting = true
			
		if type in ["bomb", "tnt"]:
			loose_heart()
		body.queue_free()

func calculate_score():
	score_juice = 0
	
	for type in object_counts.keys():
		var probability = 1.0
		for i in range(object_scenes.size()):
			if object_scenes[i].resource_path and object_scenes[i].resource_path.get_file().get_basename() == type:
				probability = spawn_probabilities[i] if i < spawn_probabilities.size() else 1.0
				break
		
		var rarity_factor = 1.0 / probability if probability > 0 else 1.0
		
		if type in ["bomb", "tnt"]:
			score_juice -= object_counts[type] * 40 * rarity_factor
		else:
			score_juice += object_counts[type] * 40 * rarity_factor
	
	score_juice = max(score_juice, 0)

func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(score_juice)

func loose_heart():
	if hearts == 3:
		$CanvasLayer/Heart1.visible = false
		$CanvasLayer/Heart1Off.visible = true
		hearts -= 1
	elif hearts == 2:
		$CanvasLayer/Heart2.visible = false
		$CanvasLayer/Heart2Off.visible = true
		hearts -= 1
	elif hearts == 1:
		$CanvasLayer/Heart3.visible = false
		$CanvasLayer/Heart3Off.visible = true
		dead()

func dead():
	finish_juice.visible = true
	is_spawning = false
	dead_juice.emit()
	game_over = true
	Global.juice_minigame_finished = true
	Global.add_score(score_juice)

func _on_finish_juice_restart_juice() -> void:
	if game_over:
		reset_game()

func _on_finish_juice_desktop_return_from_juice() -> void:
	desktop_return_from_juice.emit()
	finish_juice.visible = false
	game_over = false
	Global.tokens += 1

func _on_timer_timeout() -> void:
	if Global.desktop_juice_visible == true:
		dead()
	else:
		return
