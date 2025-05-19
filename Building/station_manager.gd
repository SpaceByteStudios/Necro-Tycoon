extends Node2D

@onready var marker_scene = preload('res://Building/station_marker.tscn')

@export var building_layer : BuildingLayer

var building_cells : Array[Vector2i]

func _ready() -> void:
	building_cells = building_layer.return_building_cells()
	
	for cell in building_cells:
		var pos = building_layer.map_to_local(cell)
		pos.y -= 16
		
		var marker : Node2D = marker_scene.instantiate()
		marker.global_position = pos
		add_child(marker)
