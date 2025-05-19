extends TrainWagon
class_name CarrierWagon

var station_manager : StationManager

var cargo : ProductType

func _on_station_area_body_entered(body: Node2D) -> void:
	var map_pos = station_manager.get_cell_pos(global_position)
	var marker : StationMarker = station_manager.get_station_marker(map_pos)
