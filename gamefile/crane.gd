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
var target_camera_position: Vector2
var block_scenes = [
	preload("res://blocks/block_32.tscn"),
	preload("res://blocks/block_48.tscn"),
	preload("res://blocks/block_64.tscn"),
	preload("res://blocks/block_96.tscn")]
	
func _ready():
	start_x = position.x
	highest_block_y = drop_point.global_position.y
	target_camera_position = camera.position
	print("Initiale Höhe des Turms:", highest_block_y)
	
func _process(delta):
	if Global.desktop_crane_visible or test:
		position.x += direction * speed * delta
		if position.x >= start_x + move_range and not has_spawned_block:
			has_spawned_block = true
			spawn_block()
			speed += speed_increase
		if position.x > start_x + move_range:
			direction = -1
		elif position.x < start_x - move_range:
			direction = 1
			has_spawned_block = false
		if current_block and is_block_attached:
			current_block.global_position = drop_point.global_position
		if current_block and is_block_attached:
			check_tower_height(current_block.global_position.y)
		camera.position = camera.position.lerp(target_camera_position, 0.01)

func spawn_block():
	if current_block != null:
		return
	var random_block = block_scenes[randi() % block_scenes.size()]
	current_block = random_block.instantiate()
	get_tree().current_scene.call_deferred("add_child", current_block)
	current_block.global_position = drop_point.global_position  
	current_block.freeze = true  
	current_block.gravity_scale = 0  
	is_block_attached = true  
	print("Block instanziiert mit Y-Position: ", current_block.global_position.y)
	
func drop_block():
	if current_block and is_block_attached:
		is_block_attached = false
		current_block.freeze = false
		current_block.gravity_scale = 1
		await get_tree().create_timer(0.5).timeout
		check_tower_height(current_block.global_position.y)
		current_block = null  

func check_tower_height(new_block_y):
	print("Überprüfe Höhe: neuer Block Y = ", new_block_y, " aktuelle höchste Y = ", highest_block_y)
	if new_block_y <= highest_block_y:
		print("Kein Wachstum! Block ist nicht höher.")
		return
	
	highest_block_y = new_block_y
	print("Aktualisierte höchste Y-Position des Turms: ", highest_block_y)

	var move_up = Vector2(0, -camera_follow_offset)
	print("🔼 Turm wächst! Kamera nach oben:", move_up)
	target_camera_position = camera.position + move_up

func _input(event):
	if event.is_action_pressed("ui_accept"):
		drop_block()
