extends Node2D

@export var object_scenes: Array[PackedScene]
@export var spawn_probabilities: Array[float]

@export var spawn_x_min: float = -300
@export var spawn_x_max: float = 300

@export var spawn_y_min: float = -900
@export var spawn_y_max: float = -650

@export var spawn_rate_min: float = 1.0
@export var spawn_rate_max: float = 4.5

@export var explosion_texture : Texture
@export var explosion_lifetime : float = 0.5

var spawn_timer: Timer
var is_spawning: bool = false
@export var test: bool = false

var object_counts = {}

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
			
			if type == "bomb" or type == "tnt":
				explode(body)

func explode(body):
	# Erstelle den Partikeleffekt für die Explosion
	var explosion = GPUParticles2D.new()
	explosion.position = body.position
	explosion.emitting = true
	
	# Explosionseinstellungen
	var particles_material = ShaderMaterial.new()
	var shader = Shader.new()  # Hier kannst du einen eigenen Shader hinzufügen (optional)
	particles_material.shader = shader  # Setze den Shader auf das Material

	# Setze die Textur für die Partikel
	particles_material.set_shader_parameter("texture", explosion_texture)
	explosion.process_material = particles_material  # Weisen Sie das Material den Partikeln zu

	# Füge die Explosion zum aktuellen Node hinzu
	add_child(explosion)

	# Starte den Timer für die Lebensdauer der Explosion
	var timer = Timer.new()
	timer.one_shot = true  # Timer wird nur einmal ausgeführt
	timer.wait_time = explosion_lifetime
	add_child(timer)
	timer.start()

	# Warten auf das Timeout-Signal des Timers, bevor wir die Explosion und das Objekt entfernen
	timer.timeout.connect(func():
		explosion.queue_free()
		body.queue_free()
	)
