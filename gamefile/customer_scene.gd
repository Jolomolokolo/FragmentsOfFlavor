class_name Customer
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var speed = 200

@export var orders: Array[String] = ["crumb_cake", "cheescake", "cookie", "coffe", "avocado_toast", "soup", "hot_chocolat", "cola", "energy", "water", "cookie"]
var order: String
var order_sucessfull = false
var player_was = false
var player_in_area = false
var rng = round(randf_range(5, 10))

@onready var bubble = $Control
@onready var image_display = $Control/TextureRect2/TextureRect
@onready var image_display_bg = $Control/TextureRect2
@onready var satisfaction_bar = $SatisfactionBar
@onready var timer = $Timer
@onready var timer_leave = $TimerLeave
@onready var particle = $GPUParticles2D
@onready var booster = get_node("/root/Cafe/BoosterLayer/TimeAddBooster")

@export var max_satisfaction_time: float = 300.0
var satisfaction_time_left: float

var product_images: Dictionary = {
	"crumb_cake": preload("res://food/food_icon/crumb_cake.png"),
	"cheescake": preload("res://food/food_icon/cheescake.png"),
	"cookie": preload("res://food/food_icon/cookie.png"),
	"coffe": preload("res://food/food_icon/coffe.png"),
	"avocado_toast": preload("res://food/food_icon/avocado_toast.png"),
	"soup": preload("res://food/food_icon/soup.png"),
	"hot_chocolat": preload("res://food/food_icon/hot_chocolate.png"),
	"cola": preload("res://food/food_icon/cola.png"),
	"energy": preload("res://food/food_icon/energy.png"),
	"water": preload("res://food/food_icon/water.png")
}
var hook = preload("res://icons/hook.png")

func _ready():
	particle.emitting = true
	order = orders[randi() % orders.size()]
	bubble.visible = false
	image_display.visible = false
	image_display_bg.visible = false
	satisfaction_time_left = max_satisfaction_time

	if satisfaction_bar:
		satisfaction_bar.max_value = max_satisfaction_time
		satisfaction_bar.value = satisfaction_time_left
		satisfaction_bar.visible = true
		satisfaction_bar.modulate = Color(0, 1, 0)
	
	if booster:
		booster.time_add.connect(_on_time_boost)
	
	timer.start(1.0)

func _process(_delta: float):
	if satisfaction_bar:
		var progress = satisfaction_time_left / max_satisfaction_time
		var color = Color(1.0 - progress, progress, 0)
		satisfaction_bar.modulate = color

	if player_in_area and Input.is_action_just_pressed("ui_action"):
		if Global.handheld == order and Global.handheld_selected_main and not order_sucessfull:
			complete_order(1)
		elif Global.handheld_2 == order and not Global.handheld_selected_main and not order_sucessfull:
			complete_order(2)
		elif not order_sucessfull:
			Global.health -= 2

func complete_order(slot: int):
	order_sucessfull = true
	image_display.texture = hook
	
	if slot == 1:
		Global.handheld = ""
		Global.handheld_bool_1 = false
	elif slot == 2:
		Global.handheld_2 = ""
		Global.handheld_bool_2 = false
	
	Global.cash += rng
	Global.health += 3
	Global.orders_served += 1
	
	var index = Global.orders.find(order)
	if index != -1:
		Global.orders.remove_at(index)
	
	timer_leave.start()

func customer_leave():
	Global.health -= 10
	Global.orders_failed += 1
	var index = Global.orders.find(order)
	if index != -1:
		Global.orders.remove_at(index)
	queue_free()

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		if not player_was:
			Global.orders.append(order)
			player_was = true
		if product_images.has(order) and not order_sucessfull:
			image_display.texture = product_images[order]
			image_display.visible = true
			image_display_bg.visible = true
		show_bubble()

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		image_display.visible = false
		image_display_bg.visible = false
		hide_bubble()

func show_bubble():
	bubble.visible = true

func hide_bubble():
	bubble.visible = false

func _on_timer_timeout() -> void:
	if not order_sucessfull:
		satisfaction_time_left -= 1
		satisfaction_time_left = max(satisfaction_time_left, 0)
		
		if satisfaction_bar:
			satisfaction_bar.value = satisfaction_time_left
			
		if satisfaction_time_left <= 0:
			customer_leave()

func _on_timer_leave_timeout() -> void:
	queue_free()

func _on_time_boost(extra_time: int):
	satisfaction_time_left += extra_time
	if satisfaction_bar:
		satisfaction_bar.max_value += extra_time
		satisfaction_bar.value = satisfaction_time_left
	print("⚡ Booster aktiviert! Neue Zufriedenheitszeit:", satisfaction_time_left)
