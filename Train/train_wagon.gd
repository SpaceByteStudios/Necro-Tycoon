extends CharacterBody2D
class_name TrainWagon

var rail_layer : RailManager

var previous_dir : Vector2i
var current_dir : Vector2i = Vector2i.LEFT
var current_map_pos : Vector2i

var start_pos : Vector2
var end_pos : Vector2

var rail_type : String

var progress_amount : float

func _process(delta: float) -> void:
	move_train()

func setup_wagon():
	current_map_pos = rail_layer.get_map_pos(global_position)
	start_rail(current_map_pos)

func start_rail(map_pos):
	rail_type = rail_layer.get_rail_type(map_pos)
	
	var points = rail_layer.get_start_end_point(map_pos, current_dir)
	
	start_pos = points[0]
	end_pos = points[1]
	
	previous_dir = current_dir
	current_dir = rail_layer.get_forward_direction(current_map_pos, current_dir)
	
	global_position = start_pos

func start_next_rail():
	current_map_pos += current_dir
	start_rail(current_map_pos)

func move_train():
	match rail_type:
		"Straight":
			linear_movement()
		"Curve":
			circular_movement()

func set_progress(progress):
	progress_amount = progress

func linear_movement():
	var target_position = start_pos.lerp(end_pos, progress_amount)
	
	var motion = target_position - global_position
	global_position += motion
	look_at(global_position + motion)

func circular_movement():
	var is_clockwise = is_turn_clockwise(previous_dir, current_dir)
	var center = find_circle_center(start_pos, end_pos, 8.0, is_clockwise)
	
	var target_position = quadratic_bezier(start_pos, center, end_pos, progress_amount)
	
	var motion = target_position - global_position
	global_position += motion
	look_at(global_position + motion)	

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
