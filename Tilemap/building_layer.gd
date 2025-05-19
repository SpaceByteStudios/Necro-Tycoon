extends TileMapLayer
class_name BuildingLayer

func has_building_neighbors(map_pos):
	var cells = get_surrounding_cells(map_pos)
	
	for cell in cells:
		var tile_data = get_cell_tile_data(cell)
		
		if tile_data == null:
			continue
		
		var is_building = tile_data.get_custom_data("IsBuilding")
		if is_building:
			return true
	
	return false
