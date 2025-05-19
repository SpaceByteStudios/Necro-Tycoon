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

func return_building_cells():
	var cells = get_used_cells()
	var building_cells : Array[Vector2i]
	
	for cell in cells:
		var tile_data = get_cell_tile_data(cell)
		
		if tile_data == null:
			continue
		
		var is_building = tile_data.get_custom_data("IsBuilding")
		if is_building:
			building_cells.append(cell)
	
	return building_cells

func get_building_neighbor(map_pos):
	if has_building_neighbors(map_pos):
		var cells = get_surrounding_cells(map_pos)
		
		for cell in cells:
			var tile_data = get_cell_tile_data(cell)
			
			if tile_data == null:
				continue
		
			var is_building = tile_data.get_custom_data("IsBuilding")
			if is_building:
				return cell
	else:
		return null

func get_map_pos(global_pos):
	var local_rail = to_local(global_pos)
	var map_pos = local_to_map(local_rail)
	return map_pos
