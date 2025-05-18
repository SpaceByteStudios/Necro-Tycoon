extends Node2D

@onready var train_sprite = $Train
@onready var wagons_sprite = $Wagons
@onready var rail_sprite = $RailSprite
@onready var station_sprite = $StationSprite

@onready var train_scene = preload('res://Train/train.tscn')

@export var rail_layer : RailLayer
@export var building_layer : BuildingLayer

enum BuildState{
	NONE,
	TRAIN,
	RAIL,
	STATION
}

signal state_deselected

var build_state : BuildState = BuildState.NONE

var train_index = 0

func _on_ui_button_toggled_off() -> void:
	build_state = BuildState.NONE
	train_sprite.modulate = Color(Color.WHITE, 0.0)
	rail_sprite.modulate = Color(Color.WHITE, 0.0)
	station_sprite.modulate = Color(Color.WHITE, 0.0)

func _on_ui_train_button_pressed() -> void:
	build_state = BuildState.TRAIN
	train_sprite.modulate = Color(Color.WHITE, 0.8)

func _on_ui_rail_button_pressed() -> void:
	build_state = BuildState.RAIL
	rail_sprite.modulate = Color(Color.WHITE, 0.8)

func _on_ui_station_button_pressed() -> void:
	build_state = BuildState.STATION
	station_sprite.modulate = Color(Color.WHITE, 0.8)

func _process(_delta: float) -> void:
	match build_state:
		BuildState.TRAIN:
			placing_train()
		BuildState.RAIL:
			placing_rail()
		BuildState.STATION:
			placing_station()

func placing_train():
	var map_pos = get_mouse_map_pos()
	var tile_pos = rail_layer.map_to_local(map_pos)
	var tile_data = rail_layer.get_cell_tile_data(map_pos)
	
	train_sprite.global_position = tile_pos
	wagons_sprite.global_position = tile_pos
	
	if tile_data == null:
		wagons_sprite.modulate = Color(Color.WHITE, 0.0)
		return
	
	var new_dir = tile_data.get_custom_data("StartDir")
	if new_dir == Vector2i.ZERO:
		return
	
	wagons_sprite.modulate = Color(Color.WHITE, 0.8)
	
	var angle = atan2(new_dir.y, new_dir.x)
	train_sprite.rotation = angle
	wagons_sprite.rotation = angle
	
	var is_cosnsecutive = rail_layer.check_consecutive_rail(map_pos, new_dir, 4)
	if !is_cosnsecutive:
		return
	
	if Input.is_action_just_pressed('Place'):
		var train : Train = train_scene.instantiate()
		train.global_position = tile_pos
		train.train_id = train_index
		train.rail_layer = rail_layer
		train.direction = new_dir
		train.current_speed = 0.0
		
		get_tree().root.add_child(train)
		
		state_deselected.emit()
		build_state = BuildState.NONE
		train_sprite.modulate = Color(Color.WHITE, 0.0)
		wagons_sprite.modulate = Color(Color.WHITE, 0.0)
		train_index += 1

func placing_rail():
	var map_pos = get_mouse_map_pos()
	
	var building_data = building_layer.get_cell_tile_data(map_pos)
	if building_data != null:
		rail_sprite.modulate = Color(Color.WHITE, 0.0)
		return
	
	rail_sprite.modulate = Color(Color.WHITE, 0.8)
	
	var tile_pos = rail_layer.map_to_local(map_pos)
	var cells = [map_pos]
	rail_sprite.global_position = tile_pos
	
	if Input.is_action_pressed('Place'):
		rail_layer.set_cells_terrain_connect(cells, 0, 0)
	
	if Input.is_action_pressed('Remove'):
		rail_layer.set_cells_terrain_connect(cells, 0, -1)

func placing_station():
	var map_pos = get_mouse_map_pos()
	var tile_pos = rail_layer.map_to_local(map_pos)
	station_sprite.global_position = tile_pos

func get_mouse_map_pos():
	var mouse_pos = get_global_mouse_position()
	return rail_layer.get_map_pos(mouse_pos)
	
