extends CharacterBody2D
class_name TrainCar

var rail_layer : RailManager
var current_speed = 0.0
var train_speed = 16.0
var train_acceleration = 10.0

var previous_dir : Vector2i
var current_dir : Vector2i = Vector2i.LEFT
var current_map_pos : Vector2i

var start_pos : Vector2
var end_pos : Vector2

var rail_type : String
var rail_length : float

var traveled_dist : float

func _ready() -> void:
	var local_rail = rail_layer.to_local(global_position)
	var map_pos = rail_layer.local_to_map(local_rail)
	current_map_pos = map_pos
	
	start_rail(current_map_pos)

func _process(delta: float) -> void:
	accelerate_train()
	move_train()

func start_rail(map_pos):
	rail_type = rail_layer.get_rail_type(map_pos)
	
	match rail_type:
		"Straight":
			rail_length = 16.0
		"Curve":
			rail_length = (PI * 16.0) / 4.0
	
	var points = rail_layer.get_start_end_point(map_pos, current_dir)
	
	start_pos = points[0]
	end_pos = points[-2]
	
	previous_dir = current_dir
	current_dir = Vector2i(points[-1])
	
	traveled_dist = 0.0
	global_position = start_pos

func move_train():
	match rail_type:
		"Straight":
			linear_movement()
		"Curve":
			circular_movement()
	
	traveled_dist += current_speed * get_process_delta_time()
	
	if traveled_dist >= rail_length:
		current_map_pos += current_dir
		start_rail(current_map_pos)

func linear_movement():
	var move_dir = (end_pos - global_position).normalized()
	var motion = move_dir * current_speed * get_process_delta_time()
	global_position += motion
	look_at(global_position + Vector2(current_dir))

func circular_movement():
	var is_clockwise = is_turn_clockwise(previous_dir, current_dir)
	var center = find_circle_center(start_pos, end_pos, 8.0, is_clockwise)
	
	var progress = traveled_dist / rail_length
	
	var target_position = quadratic_bezier(start_pos, center, end_pos, progress)
	
	var motion = target_position - global_position
	global_position += motion
	look_at(global_position + motion)	

func accelerate_train():
	current_speed += train_acceleration * get_process_delta_time()
	current_speed = minf(current_speed, train_speed)

func is_turn_clockwise(from_dir: Vector2, to_dir: Vector2) -> bool:
	var cross = from_dir.x * to_dir.y - from_dir.y * to_dir.x
	return cross > 0

func find_circle_center(p1, p2, radius, is_clockwise):
	var midpoint = (p1 + p2) / 2.0
	
	var vec = p2 - p1
	var vec_length = vec.length()
	var perp = Vector2(-vec.y, vec.x).normalized()
	
	var h = radius * sqrt(2) / 2.0
	
	var center1 = midpoint + perp * h
	var center2 = midpoint - perp * h
	
	if is_clockwise:
		return center2
	else:
		return center1

func quadratic_bezier(p0, p1, p2, t):
	var a = p0.lerp(p1, t)
	var b = p1.lerp(p2, t)
	return a.lerp(b, t)
