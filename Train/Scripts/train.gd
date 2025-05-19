extends Node2D
class_name Train

@onready var engine = $Engine
@onready var particles = $Engine/SmokeParticles
@onready var wagon_scene = preload('res://Train/wagon.tscn')

@export var train_id : int

@export var rail_layer : RailLayer
@export var wagon_amount : int
@export var train_speed = 16.0
@export var acceleration = 10.0

@export_enum("Left", "Right", "Up", "Down")
var start_dir : String

var direction : Vector2i = Vector2i.ZERO
var current_speed : float

var progress_t : float
var traveled_dist : float
var rail_length : float = 16.0

var wagons : Array[TrainWagon]

var station_manager : StationManager

func _ready() -> void:
	particles.emitting = true
	
	if direction == Vector2i.ZERO:
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
	engine.destroy_train.connect(_on_destroy_train)
	engine.setup_wagon(train_id)
	wagons.push_back(engine)
	
	var wagon_dir = engine.current_dir
	var wagon_global_pos = engine.global_position
	for i in wagon_amount:
		var wagon : CarrierWagon = wagon_scene.instantiate()
		
		wagon_global_pos -= wagon_dir * 15.99
		var wagon_map_pos = rail_layer.get_map_pos(wagon_global_pos)
		
		var rail_type = rail_layer.get_rail_type(wagon_map_pos)
		if rail_type == "Curve" || rail_type == null:
			break
		
		add_child(wagon)
		
		wagon.global_position = wagon_global_pos
		wagon.rail_layer = rail_layer
		wagon.current_dir = direction
		wagon.destroy_train.connect(_on_destroy_train)
		wagon.station_manager = station_manager
		
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

func _on_destroy_train() -> void:
	queue_free()

func _on_clickable_input_event(_viewport: Node, event: InputEvent, _shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		flip_train()

func flip_train():
	var cached_progress = wagons[0].progress_amount
	var cached_data = []
	
	for wagon in wagons:
		if wagon.rail_type == "Junction":
			return
		
		cached_data.append({
			"map_pos" : wagon.current_map_pos,
			"current_dir" : wagon.current_dir
		})
	
	current_speed = 0.0
	
	for i in wagons.size():
		var j = wagons.size() - i - 1
		var wagon = wagons[i]
		var data = cached_data[j]
		
		wagon.current_map_pos = data["map_pos"]
		wagon.current_dir = -data["current_dir"]
		
		wagon.start_rail(wagon.current_map_pos)
		wagon.set_progress(cached_progress)
