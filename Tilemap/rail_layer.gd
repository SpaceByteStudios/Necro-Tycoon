extends TileMapLayer
class_name RailLayer

var bridge_tiles : Array[Vector2i]

@export var ground_layer : GroundLayer

func print_tile_info(map_pos):
	var tile_pos = map_to_local(map_pos)
	var tile_data = get_cell_tile_data(map_pos)
	var type = tile_data.get_custom_data("Type")
	var directions = tile_data.get_custom_data("Direction")
	
	print(tile_pos)
	print(type)
	
	for dir in directions:
		var scaled_dir = Vector2i(dir) * tile_set.tile_size / 2
		var dir_pos = Vector2i(tile_pos) + scaled_dir
		print(dir_pos)

func get_start_end_point(map_pos, direction):
	var tile_pos = map_to_local(map_pos)
	var directions = get_directions(map_pos)
	var rail_type = get_rail_type(map_pos)
	
	var start_point : Vector2
	var end_points : Array[Vector2]
	var points : Array[Vector2]
	
	for dir in directions:
		var scaled_dir = Vector2i(dir) * tile_set.tile_size / 2
		var dir_pos = Vector2i(tile_pos) + scaled_dir
		
		if direction + Vector2i(dir) == Vector2i.ZERO:
			start_point = Vector2(dir_pos)
		elif rail_type != "Crossing":
			end_points.append(Vector2(dir_pos))
		elif direction - Vector2i(dir) == Vector2i.ZERO:
			end_points.append(Vector2(dir_pos))
	
	points.append(start_point)
	points.append_array(end_points)
	
	return points

func get_forward_direction(map_pos, back_direction):
	var directions = get_directions(map_pos)
	
	for dir in directions:
		if back_direction + Vector2i(dir) == Vector2i.ZERO:
			return Vector2i(dir)
	
	return null

func get_curve_direction(map_pos, back_direction):
	var directions = get_directions(map_pos)
	
	for dir in directions:
		if back_direction - Vector2i(dir) != Vector2i.ZERO:
			return Vector2i(dir)
	
	return null

func get_directions(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	var directions = tile_data.get_custom_data("Direction")
	return directions

func get_rail_type(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	if tile_data != null:
		var type = tile_data.get_custom_data("Type")
		return type
	else:
		return null

func get_map_pos(global_pos):
	var local_rail = to_local(global_pos)
	var map_pos = local_to_map(local_rail)
	return map_pos

func check_consecutive_rail(map_pos, forward_dir, length):
	var tile_pos = map_to_local(map_pos)
	
	for i in length:
		tile_pos -= forward_dir * 15.99
		var tile_map_pos = local_to_map(tile_pos)
		var tile_type = get_rail_type(tile_map_pos)
		if tile_type == "Curve" || tile_type == null:
			return false
	
	return true

func build_bridge(map_pos):
	var is_river = ground_layer.is_cell_river(map_pos)
	
	if is_river:
		var is_wasteland = ground_layer.is_cell_wasteland(map_pos)
		var is_horizontal = ground_layer.is_cell_horizontal(map_pos)
		if is_wasteland:
			if is_horizontal:
				set_cell(map_pos, 0, Vector2i(2, 5))
			else:
				set_cell(map_pos, 0, Vector2i(3, 5))
		else:
			if is_horizontal:
				set_cell(map_pos, 0, Vector2i(0, 5))
			else:
				set_cell(map_pos, 0, Vector2i(1, 5))
		
		finalize_bridge(map_pos, is_horizontal)

func finalize_bridge(map_pos, is_horizontal):
	var vector1 : Vector2i
	var vector2 : Vector2i
	var atlas_coord : Vector2i
	
	if is_horizontal:
		vector1 = Vector2i.UP
		vector2 = Vector2i.DOWN
		atlas_coord = Vector2i(0, 1)
	else:
		vector1 = Vector2i.LEFT
		vector2 = Vector2i.RIGHT
		atlas_coord = Vector2i(0, 0)
	
	set_cell(map_pos + vector1, 0, atlas_coord)
	set_cell(map_pos + vector2, 0, atlas_coord)
	
	bridge_tiles.append(map_pos)
	bridge_tiles.append(map_pos + vector1)
	bridge_tiles.append(map_pos + vector2)

func is_a_bridge(map_pos):
	return bridge_tiles.has(map_pos)
