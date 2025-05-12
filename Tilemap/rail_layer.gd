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
	var tile_data = get_cell_tile_data(map_pos)
	var directions = tile_data.get_custom_data("Direction")
	
	var start_point : Vector2
	var end_points : Array[Vector2]
	var new_dir : Vector2
	var points : Array[Vector2]
	
	for dir in directions:
		var scaled_dir = Vector2i(dir) * tile_set.tile_size / 2
		var dir_pos = Vector2i(tile_pos) + scaled_dir
		
		if direction + Vector2i(dir) == Vector2i.ZERO:
			start_point = Vector2(dir_pos)
		else:
			end_points.append(Vector2(dir_pos))
			new_dir = dir
	
	points.append(start_point)
	points.append_array(end_points)
	points.append(new_dir)
	
	return points

func get_rail_type(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	var type = tile_data.get_custom_data("Type")
	return type
