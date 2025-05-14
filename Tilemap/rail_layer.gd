extends TileMapLayer
class_name RailManager

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
	
	var start_point : Vector2
	var end_points : Array[Vector2]
	var points : Array[Vector2]
	
	for dir in directions:
		var scaled_dir = Vector2i(dir) * tile_set.tile_size / 2
		var dir_pos = Vector2i(tile_pos) + scaled_dir
		
		if direction + Vector2i(dir) == Vector2i.ZERO:
			start_point = Vector2(dir_pos)
		else:
			end_points.append(Vector2(dir_pos))
	
	points.append(start_point)
	points.append_array(end_points)
	
	return points

func get_forward_direction(map_pos, back_direction):
	var directions = get_directions(map_pos)
	
	for dir in directions:
		if back_direction + Vector2i(dir) != Vector2i.ZERO:
			return Vector2i(dir)

func get_backward_direction(map_pos, for_direction):
	var directions = get_directions(map_pos)
	
	for dir in directions:
		if for_direction + Vector2i(dir) == Vector2i.ZERO:
			return Vector2i(dir)

func get_directions(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	var directions = tile_data.get_custom_data("Direction")
	return directions

func get_rail_type(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	var type = tile_data.get_custom_data("Type")
	return type

func get_map_pos(global_pos):
	var local_rail = to_local(global_pos)
	var map_pos = local_to_map(local_rail)
	return map_pos
