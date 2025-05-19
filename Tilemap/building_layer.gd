extends TileMapLayer
class_name BuildingLayer

@export var product_array : Array[ProductType]

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

func get_building_cells():
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

func get_building_production(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return product_array[0]
	
	var product = tile_data.get_custom_data("Production")
	
	match product:
		"Nothing":
			return product_array[0]
		"Skeleton":
			return product_array[1]
		"Bonemeal":
			return product_array[2]
		"Carrot":
			return product_array[3]
		"Ore":
			return product_array[4]
		"Iron":
			return product_array[5]
		"Weapons":
			return product_array[6]
		"Money":
			return product_array[7]

func get_building_accepts(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return product_array[0]
	
	var product = tile_data.get_custom_data("Accepts")
	
	match product:
		"Nothing":
			return product_array[0]
		"Skeleton":
			return product_array[1]
		"Bonemeal":
			return product_array[2]
		"Carrot":
			return product_array[3]
		"Ore":
			return product_array[4]
		"Iron":
			return product_array[5]
		"Weapon":
			return product_array[6]

func set_building_id(map_pos, id):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return
	
	tile_data.set_custom_data("MarkerID", id)

func get_building_id(map_pos):
	var tile_data = get_cell_tile_data(map_pos)
	
	if tile_data == null:
		return
	
	return tile_data.get_custom_data("MarkerID")

func get_map_pos(global_pos):
	var local_rail = to_local(global_pos)
	var map_pos = local_to_map(local_rail)
	return map_pos
