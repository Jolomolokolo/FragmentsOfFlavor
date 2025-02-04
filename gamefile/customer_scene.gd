class_name Customer
extends CharacterBody2D

@onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
@export var speed = 200

@export var orders: Array[String] = ["crumb_cake", "cheescake", "cookie", "coffe", "avocado_toast", "soup", "hot_chocolat", "cola", "energy", "water", "cookie"]
var order: String
var order_sucessfull = false
var player_was = false
var player_final_pos = false
var player_in_area = false
var rng = round(randf_range(5,10))

@onready var bubble = $Control
@onready var image_display = $Control/TextureRect2/TextureRect
@onready var image_display_bg = $Control/TextureRect2

var product_images: Dictionary = {
	"crumb_cake": preload("res://food/food_icon/crumb_cake.png"),
	"cheescake": preload("res://food/food_icon/cheescake.png"),
	"cookie": preload("res://food/food_icon/cookie.png"),
	"coffe": preload("res://food/food_icon/coffe.png"),
	"avacado_toast": preload("res://food/food_icon/avocado_toast.png"),
	"soup": preload("res://food/food_icon/soup.png"),
	"hot_chocolat": preload("res://food/food_icon/hot_chocolate.png"),
	"cola": preload("res://food/food_icon/cola.png"),
	"energy": preload("res://food/food_icon/energy.png"),
	"water": preload("res://food/food_icon/water.png")
}
var hook = preload("res://icons/hook.png")

func _ready():
	order = orders[randi() % orders.size()]
	bubble.visible = false
	image_display.visible = false
	image_display_bg.visible = false

func _process(_delta: float):
	if player_in_area == true and Input.is_action_just_pressed("ui_action") == true:
		if Global.handheld == order:
			Global.handheld = ""
			Global.handheld_bool = false
			Global.cash += rng
			Global.health += 1
			print(Global.cash)
			order_sucessfull = true
			image_display.texture = hook
			var index = Global.orders.find(order)
			if index != -1:
				Global.orders.remove_at(index)
			$Timer2.start()
			print("Order sucessfull")

func _on_area_2d_body_entered(body):
	if body.is_in_group("player"):
		player_in_area = true
		#print("Player da!")
		if not player_was:
			Global.orders.append(order)
			print(Global.orders)
			player_was = true
		if product_images.has(order) and order_sucessfull == false:
			image_display.texture = product_images[order]
			image_display.visible = true
			image_display_bg.visible = true
		show_bubble()

func _on_area_2d_body_exited(body) -> void:
	if body.is_in_group("player"):
		player_in_area = false
		#print("Player weg!")
		image_display.visible = false
		image_display_bg.visible = false
		hide_bubble()

func show_bubble():
	bubble.visible = true

func hide_bubble():
	bubble.visible = false

func _on_timer_timeout() -> void:
	if order_sucessfull == false:
		Global.health -= 10
		var index = Global.orders.find(order)
		if index != -1:
			Global.orders.remove_at(index)
		print("WEG: ", Global.health)
	queue_free()
	
func _on_timer_2_timeout() -> void:
	queue_free()

#func make_path(target: Vector2) -> void:
	#position = target
	#print("TPed")
	#nav_agent.target_position = target

# func _physics_process(delta: float) -> void:
#	var next_pos = nav_agent.get_next_path_position()
#	var drc = global_position.direction_to(next_pos)
#	var unsafe_velocity = drc * speed * delta
#	nav_agent.velocity = unsafe_velocity
#
# func _on_safe_velocity_computed(safe_velocity: Vector2) -> void:
#	velocity = velocity.move_toward(safe_velocity, 100)
#	if not nav_agent.is_navigation_finished():
#		move_and_collide(velocity)
#		
#	if nav_agent.distance_to_target() <= 25:
#		nav_agent.set_velocity_forced(Vector2.ZERO)
#		position = nav_agent.target_position
#	elif nav_agent.is_navigation_finished() == true and nav_agent.distance_to_target() >= 25:
#		position = nav_agent.target_position
#		print("Desti TP")


#	print("Nav finished")
