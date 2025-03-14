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

var crane_offset: float = 160

var crane = self

func _ready():
	start_x = position.x
	highest_block_y = drop_point.global_position.y
	target_camera_position = camera.global_position
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
		update_camera_height()

		camera.global_position = Vector2(int(target_camera_position.x), int(target_camera_position.y))

		crane.global_position.y = camera.global_position.y - crane_offset

		crane.global_position.x = position.x

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
	print("Block instanziiert mit globaler Y-Position: ", current_block.global_position.y)

func drop_block():
	if current_block and is_block_attached:
		is_block_attached = false
		current_block.gravity_scale = 1
		await get_tree().create_timer(0.5).timeout
		update_camera_height()
		current_block = null  

func update_camera_height():
	var all_blocks = []
	var block_to_ignore = current_block

	for body in get_tree().get_nodes_in_group("blocks"):
		if body is RigidBody2D and body != block_to_ignore:
			all_blocks.append(int(body.global_position.y))

	print("Gefundene Blöcke mit globalen Höhen: ", all_blocks)

	if all_blocks.size() < 2:
		print("Nicht genug existierende Blöcke. Alle Blockhöhen:", all_blocks)
		return
	
	all_blocks.sort()
	var highest_blocks = all_blocks.slice(0, 2)

	print("Höchste Blockhöhen: ", highest_blocks)

	var camera_y = highest_blocks[1] - camera_follow_offset

	camera_y = int(camera_y)

	target_camera_position = Vector2(camera.global_position.x, camera_y)

	camera.global_position = camera.global_position.lerp(target_camera_position, 0.1)

func _input(event):
	if event.is_action_pressed("ui_accept"):
		drop_block()
