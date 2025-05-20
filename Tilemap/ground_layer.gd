extends TileMapLayer
class_name GroundLayer

func is_cell_river(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return null
	
	return tile_data.get_custom_data("IsRiver")

func is_cell_wasteland(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return null
	
	return tile_data.get_custom_data("IsWasteland")

func is_cell_horizontal(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return null
	
	return tile_data.get_custom_data("IsHorizontal")
