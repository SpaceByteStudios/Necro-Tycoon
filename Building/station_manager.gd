extends Node2D
class_name StationManager

@onready var marker_scene = preload('res://Building/station_marker.tscn')

@onready var signs = $SignsLayer
@onready var markers = $Markers

@export var building_layer : BuildingLayer

enum Mode{
	NONE,
	MARKERS,
	SIGNS
}

var mode = Mode.MARKERS

var markers_dict : Dictionary[Vector2i, int]

var markers_array : Array[StationMarker]

func _ready() -> void:
	markers.visible = true
	signs.visible = false
	
	var building_cells = building_layer.get_building_cells()
	
	for i in building_cells.size():
		var pos = building_layer.map_to_local(building_cells[i])
		pos.y -= 16
		
		var marker : StationMarker = marker_scene.instantiate()
		marker.global_position = pos
		markers_dict.set(building_cells[i], i)
		marker.production = building_layer.get_building_production(building_cells[i])
		marker.accepts = building_layer.get_building_accepts(building_cells[i])
		markers.add_child(marker)
		markers_array.push_back(marker)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed('Switch Mode'):
		match mode:
			Mode.NONE:
				mode = Mode.MARKERS
				markers.visible = true
				signs.visible = false
			Mode.MARKERS:
				mode = Mode.SIGNS
				markers.visible = true
				signs.visible = true
			Mode.SIGNS:
				mode = Mode.NONE
				markers.visible = false
				signs.visible = false

func get_cell_pos(pos):
	var map_pos = building_layer.local_to_map(pos)
	return map_pos

func get_station_marker(map_pos):
	var building_cell = building_layer.get_building_neighbor(map_pos)
	var marker_id = markers_dict.get(building_cell)
	return markers_array[marker_id]
