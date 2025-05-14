extends Node2D
class_name Train

@onready var engine = $Engine
@onready var wagon_scene = preload('res://Train/wagon.tscn')

@export var rail_layer : RailManager
@export var wagon_amount : int
@export var train_speed = 16.0
@export var acceleration = 10.0

@export_enum("Left", "Right", "Up", "Down")
var start_dir : String

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
	
	engine.rail_layer = rail_layer
	engine.current_dir = direction
	engine.setup_wagon()
	
	var wagon_dir = engine.current_dir
	var wagon_global_pos = engine.global_position
	print(wagon_global_pos)
	print(rail_layer.get_map_pos(wagon_global_pos))
	for i in wagon_amount:
		var wagon : TrainWagon = wagon_scene.instantiate()
		
		wagon_global_pos -= wagon_dir * 15.99
		
		print(wagon_global_pos)
		
		var wagon_map_pos = rail_layer.get_map_pos(wagon_global_pos)
		
		print(wagon_map_pos)
		
		if rail_layer.get_rail_type(wagon_map_pos) != "Straight":
			break
		
		add_child(wagon)
		move_child(wagon, 0)
		
		wagon.global_position = wagon_global_pos
		wagon.rail_layer = rail_layer
		wagon.current_dir = direction
		
		wagon.setup_wagon()

func _process(delta: float) -> void:
	current_speed += acceleration * get_process_delta_time()
	current_speed = minf(current_speed, train_speed)
	traveled_dist += current_speed * delta
	
	progress_t = traveled_dist / rail_length
	
	if progress_t >= 1.0:
		progress_t = 0.0
		traveled_dist = 0.0
		for child in get_children():
			if child is TrainWagon:
				child.start_next_rail()
	
	for child in get_children():
		if child is TrainWagon:
			child.set_progress(progress_t)
