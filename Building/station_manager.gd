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

var mode = Mode.NONE
var building_cells : Array[Vector2i]

func _ready() -> void:
	markers.visible = false
	signs.visible = false
	
	building_cells = building_layer.get_building_cells()
	
	for cell in building_cells:
		var pos = building_layer.map_to_local(cell)
		pos.y -= 16
		
		var marker : StationMarker = marker_scene.instantiate()
		marker.global_position = pos
		marker.production = building_layer.get_building_production(cell)
		marker.accepts = building_layer.get_building_accepts(cell)
		markers.add_child(marker)

func _process(delta: float) -> void:
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
