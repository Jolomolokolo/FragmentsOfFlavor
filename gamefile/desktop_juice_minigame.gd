extends Node2D

@export var object_scenes: Array[PackedScene]
@export var spawn_probabilities: Array[float]

@export var spawn_x_min: float = -300
@export var spawn_x_max: float = 300

@export var spawn_y_min: float = -900
@export var spawn_y_max: float = -650

@export var spawn_rate_min: float = 1.0
@export var spawn_rate_max: float = 4.5

#@export var explosion_texture : Texture
#@export var explosion_lifetime : float = 0.5

var spawn_timer: Timer
var is_spawning: bool = false
@export var test: bool = false

var object_counts = {}
var score_juice: int = 0
@onready var score_label = $CanvasLayer/Score
var hearts: int = 3

func _ready():
	spawn_timer = Timer.new()
	spawn_timer.one_shot = false
	add_child(spawn_timer)
	spawn_timer.timeout.connect(_on_spawn_timer_timeout)
	spawn_timer.wait_time = randf_range(spawn_rate_min, spawn_rate_max)

func _process(_delta):
	if Global.desktop_juice_visible and not is_spawning or test == true:
		start_spawning()
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
		set_random_spawn_time()

func spawn_object():
	if object_scenes.is_empty() or spawn_probabilities.size() != object_scenes.size():
		return

	var spawn_x = randf_range(spawn_x_min, spawn_x_max)
	var spawn_y = randf_range(spawn_y_min, spawn_y_max)
	var selected_scene = select_scene_by_probability()
	if selected_scene:
		var new_object = selected_scene.instantiate()
		new_object.position = Vector2(spawn_x + 600, spawn_y)
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
	spawn_timer.wait_time = randf_range(spawn_rate_min, spawn_rate_max)
	spawn_timer.start()

func _on_area_2d_body_entered(body):
	if body is RigidBody2D:
		var type = body.get_meta("juicer_element")
		
		if type:
			object_counts[type] = object_counts.get(type, 0) + 1
			print("Entered: ", type, " | Amount: ", object_counts[type])
			calculate_score()
			if score_juice < 0:
				score_juice = 0
				Global.juice_minigame_score = 0
			update_score_label()
		
		if type == "bomb" or type == "tnt":
			loose_heart()

func calculate_score():
	score_juice = 0 # Was ist das? Was macht das? Brauch ich das?!?

	for type in object_counts.keys():
		var probability = 1.0
		for i in range(object_scenes.size()):
			if object_scenes[i].resource_path.get_file().get_basename() == type:
				probability = spawn_probabilities[i] if i < spawn_probabilities.size() else 1.0
				break
		
		var rarity_factor = 1.0 / probability if probability > 0 else 1.0
		
		if type in ["bomb", "tnt"]:
			score_juice -= object_counts[type] * 40 * rarity_factor
		else:
			score_juice += object_counts[type] * 40 * rarity_factor
			
		Global.juice_minigame_score = score_juice
		print("Score: ", score_juice)

func update_score_label():
	if score_label:
		score_label.text = "Score: " + str(Global.juice_minigame_score)

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
		print("Dead")
		# Dead
