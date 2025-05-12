extends CharacterBody2D

@export var rail_layer : RailManager
@export var train_speed = 16.0

var current_dir : Vector2i = Vector2i.RIGHT
var current_map_pos : Vector2i

var start_pos : Vector2
var end_pos : Vector2

var progress : float
var rail_length : float

func _ready() -> void:
	var local_rail = rail_layer.to_local(global_position)
	var map_pos = rail_layer.local_to_map(local_rail)
	current_map_pos = map_pos
	
	rail_layer.print_tile_info(current_map_pos)
	
	start_rail(current_map_pos)

func _process(delta: float) -> void:
	rotate(PI * delta * 0.0)

func start_rail(map_pos):
	var rail_type = rail_layer.get_rail_type(map_pos)
	var points = rail_layer.get_start_end_point(map_pos, current_dir)
	
	start_pos = points[0]
	end_pos = points[1]
	progress = 0.0
	
	global_position = start_pos
