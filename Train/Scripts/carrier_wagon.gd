extends TrainWagon
class_name CarrierWagon

var station_manager : StationManager

func _on_station_area_body_entered(body: Node2D) -> void:
	var map_pos = station_manager.get_cell_pos(global_position)
	print(global_position)
	print(map_pos)
