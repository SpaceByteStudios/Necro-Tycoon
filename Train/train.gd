extends Node2D
class_name Train

@onready var engine = $Engine
@onready var particles = $Engine/SmokeParticles
@onready var wagon_scene = preload('res://Train/wagon.tscn')

@export var train_id : int

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

var wagons : Array[TrainWagon]

func _ready() -> void:
	particles.emitting = true
	
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
	engine.setup_wagon(train_id)
	wagons.push_back(engine)
	
	var wagon_dir = engine.current_dir
	var wagon_global_pos = engine.global_position
	for i in wagon_amount:
		var wagon : TrainWagon = wagon_scene.instantiate()
		
		wagon_global_pos -= wagon_dir * 15.99
		var wagon_map_pos = rail_layer.get_map_pos(wagon_global_pos)
		
		var rail_type = rail_layer.get_rail_type(wagon_map_pos)
		if rail_type == "Curve":
			break
		
		add_child(wagon)
		
		wagon.global_position = wagon_global_pos
		wagon.rail_layer = rail_layer
		wagon.current_dir = direction
		wagon.hitbox_entered.connect(_on_hitbox_entered)
		
		wagon.setup_wagon(train_id)
		wagons.push_back(wagon)
	
	for wagon in wagons:
		wagon.enable_train_collision()

func _process(delta: float) -> void:
	current_speed += acceleration * delta
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

func _on_hitbox_entered() -> void:
	queue_free()
