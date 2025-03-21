extends Node2D

@export var speed: float = 50  
@export var move_range: float = 100
@export var test = false
@export var speed_increase: float = 5  
@export var camera_follow_offset: int = 32
@onready var drop_point = $Marker2D  
@onready var camera: Camera2D = $"../Camera2D"
var direction: int = 1
var start_x: float
var current_block = null
var is_block_attached: bool = true  
var has_spawned_block: bool = false  
var highest_block_y: float = 0
var block_scenes = [
	preload("res://blocks/block_32.tscn"),
	preload("res://blocks/block_48.tscn"),
	preload("res://blocks/block_64.tscn"),
	preload("res://blocks/block_96.tscn")]
var initialized = false

func _ready():
	if not Global.desktop_crane_visible and not test:
		print("Szene nicht aktiv, _ready() übersprungen")
		return
	
	print("Szene aktiv, Initialisierung läuft")
	start_x = global_position.x  # Verwende global_position für den Startpunkt

func _process(delta):
	if not (Global.desktop_crane_visible or test):
		return
		
	if not initialized:
		initialized = true
	
	# Bewege den Kran horizontal relativ zur Welt
	global_position.x += direction * speed * delta
	
	# Prüfe auf Richtungswechsel und Block-Spawn mit globalen Koordinaten
	if global_position.x >= start_x + move_range:
		direction = -1
		if not has_spawned_block:
			has_spawned_block = true
			spawn_block()
			speed += speed_increase
	elif global_position.x < start_x - move_range:
		direction = 1
		has_spawned_block = false
	
	# Aktualisiere die Position des angehängten Blocks
	if current_block and is_block_attached:
		current_block.global_position = drop_point.global_position
	
	# Setze die globale X-Position der Kamera auf konstant 320
	camera.global_position.x = 320  # Globale X-Position der Kamera fixieren
	
	# Setze die lokale X-Position der Kamera auf 0, damit sie relativ zum Kran bleibt
	camera.position.x = 0  # Lokale X-Position immer 0
	
	# Aktualisiere die vertikale Kamera-Position basierend auf den Blöcken
	update_camera_height()

func spawn_block():
	if current_block != null:
		return
	var random_block = block_scenes[randi() % block_scenes.size()]
	current_block = random_block.instantiate()
	get_tree().current_scene.call_deferred("add_child", current_block)
	current_block.global_position = drop_point.global_position  
	current_block.gravity_scale = 0
	current_block.add_to_group("blocks")
	is_block_attached = true

func drop_block():
	if current_block and is_block_attached:
		is_block_attached = false
		current_block.gravity_scale = 1
		await get_tree().create_timer(0.5).timeout
		update_camera_height()
		current_block = null

func update_camera_height():
	var all_blocks = []
	for body in get_tree().get_nodes_in_group("blocks"):
		if body is RigidBody2D and body != current_block:
			all_blocks.append(float(body.global_position.y))  # Umwandlung in float
	
	if all_blocks.size() < 2:
		return
	
	# Sortiere aufsteigend (niedrigere Y-Werte = höher auf dem Bildschirm)
	all_blocks.sort()
	var highest_blocks = all_blocks.slice(0, 2)
	print("Höchste Blockhöhen: ", highest_blocks)
	
	# Berechne den vertikalen Offset für die Kamera
	var highest_y = float(highest_blocks[1]) - camera_follow_offset  # Umwandlung in float
	
	# Sanfte vertikale Anpassung (nur Y-Position)
	var current_y = global_position.y + camera.position.y  # Aktuelle globale Y-Position der Kamera
	var new_camera_y = lerp(current_y, highest_y, 0.1) - global_position.y
	
	camera.global_position.y = new_camera_y

func _input(event):
	if event.is_action_pressed("ui_accept"):
		drop_block()
