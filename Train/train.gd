extends Node2D
class_name Train

@onready var wagon_scene = preload('res://Train/wagon.tscn')

@export var rail_layer : RailManager
@export var wagon_amount : int
@export var train_speed = 16.0
@export var acceleration = 10.0

@export_enum("Left", "Right", "Up", "Down")
var start_dir : String

var engine : TrainWagon

var direction : Vector2i
var current_speed : float

var progress_t : float
var traveled_dist : float
var rail_length : float = 16.0

func _ready() -> void:
	match start_dir:
		"Left":
			direction = Vector2i.LEFT
		"Right":
			direction = Vector2i.RIGHT
		"Up":
			direction = Vector2i.UP
		"Down":
			direction = Vector2i.DOWN
	
	engine = get_child(0)
	engine.rail_layer = rail_layer
	engine.current_dir = direction
	engine.setup_wagon()
	
	var wagon_dir : Vector2i = direction
	var wagon_back_dir : Vector2i
	var wagon_global_pos = engine.global_position
	for i in wagon_amount:
		var wagon : TrainWagon = wagon_scene.instantiate()
		
		var wagon_map_pos = rail_layer.get_map_pos(wagon_global_pos)
		wagon_back_dir = rail_layer.get_backward_direction(wagon_map_pos, wagon_dir)
		
		wagon_global_pos += wagon_back_dir * 16.0
		
		print("Wagon: " + str(i + 1))
		print(wagon_map_pos)
		print(wagon_dir)
		print(wagon_back_dir)
		
		add_child(wagon)
		move_child(wagon, 0)
		
		wagon.global_position = wagon_global_pos
		wagon.rail_layer = rail_layer
		wagon.current_dir = -wagon_back_dir
		
		wagon.setup_wagon()
		
		wagon_dir = wagon.current_dir

func _process(delta: float) -> void:
	current_speed += acceleration * get_process_delta_time()
	current_speed = minf(current_speed, train_speed)
	traveled_dist += current_speed * delta
	
	progress_t = traveled_dist / rail_length
	
	if progress_t >= 1.0:
		progress_t = 0.0
		traveled_dist = 0.0
		for train_car : TrainWagon in get_children():
			train_car.start_next_rail()
	
	for train_car : TrainWagon in get_children():
			train_car.set_progress(progress_t)
