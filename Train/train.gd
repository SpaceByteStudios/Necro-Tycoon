extends Node2D
class_name Train

@export var rail_layer : RailManager
@export var train_speed = 16.0
@export var acceleration = 10.0

@export_enum("Left", "Right", "Up", "Down")
var start_dir : String

var current_dir : Vector2i

func _enter_tree() -> void:
	match start_dir:
		"Left":
			current_dir = Vector2i.LEFT
		"Right":
			current_dir = Vector2i.RIGHT
		"Up":
			current_dir = Vector2i.UP
		"Down":
			current_dir = Vector2i.DOWN
	
	print("Test")
	for train_car : TrainCar in get_children():
		print(train_car)
		train_car.train_speed = train_speed
		train_car.train_acceleration = acceleration
		train_car.rail_layer = rail_layer
		train_car.current_dir = current_dir
