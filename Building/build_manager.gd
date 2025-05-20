extends Node2D

@onready var train_sprite = $Train
@onready var wagons_sprite = $Wagons
@onready var rail_sprite = $RailSprite
@onready var station_vert_sprite = $StationVertSprite
@onready var station_hori_sprite = $StationHoriSprite

@onready var train_scene = preload('res://Train/train.tscn')

@export var ground_layer : GroundLayer
@export var rail_layer : RailLayer
@export var building_layer : BuildingLayer
@export var station_manager : StationManager
@export var money_manager : MoneyManager

@export var train_cost = 10
@export var rail_cost = 1

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
	station_vert_sprite.modulate = Color(Color.WHITE, 0.0)
	station_hori_sprite.modulate = Color(Color.WHITE, 0.0)

func _on_ui_train_button_pressed() -> void:
	build_state = BuildState.TRAIN

func _on_ui_rail_button_pressed() -> void:
	build_state = BuildState.RAIL

func _on_ui_station_button_pressed() -> void:
	build_state = BuildState.STATION

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
	
	train_sprite.modulate = Color(Color.WHITE, 1.0)
	train_sprite.global_position = tile_pos
	wagons_sprite.global_position = tile_pos
	
	if tile_data == null:
		wagons_sprite.modulate = Color(Color.WHITE, 0.0)
		return
	
	var new_dir = tile_data.get_custom_data("StartDir")
	if new_dir == Vector2i.ZERO:
		return
	
	wagons_sprite.modulate = Color(Color.WHITE, 1.0)
	
	var angle = atan2(new_dir.y, new_dir.x)
	train_sprite.rotation = angle
	wagons_sprite.rotation = angle
	
	var is_cosnsecutive = rail_layer.check_consecutive_rail(map_pos, new_dir, 4)
	if !is_cosnsecutive:
		return
	
	if Input.is_action_just_pressed('Place'):
		var enough_money = money_manager.has_enough_money(train_cost)
		if !enough_money:
			return
		
		money_manager.pay_money(train_cost)
		var train : Train = train_scene.instantiate()
		train.global_position = tile_pos
		train.train_id = train_index
		train.rail_layer = rail_layer
		train.direction = new_dir
		train.current_speed = 0.0
		train.wagon_amount = 4
		train.station_manager = station_manager
		
		get_tree().root.add_child(train)
		
		state_deselected.emit()
		build_state = BuildState.NONE
		train_sprite.modulate = Color(Color.WHITE, 0.0)
		wagons_sprite.modulate = Color(Color.WHITE, 0.0)
		train_index += 1

func placing_rail():
	var map_pos = get_mouse_map_pos()
	
	var building_data = building_layer.get_cell_tile_data(map_pos)
	var is_river = ground_layer.is_cell_river(map_pos)
	
	if building_data != null || is_river:
		rail_sprite.modulate = Color(Color.WHITE, 0.0)
		return
	
	rail_sprite.modulate = Color(Color.WHITE, 1.0)
	
	var tile_pos = rail_layer.map_to_local(map_pos)
	var cells = [map_pos]
	rail_sprite.global_position = tile_pos
	
	if Input.is_action_pressed('Place'):
		var cell = rail_layer.get_cell_source_id(cells[0])
		
		if cell != -1:
			return
		
		var enough_money = money_manager.has_enough_money(rail_cost)
		if !enough_money:
			return
		
		money_manager.pay_money(rail_cost)
		rail_layer.set_cells_terrain_connect(cells, 0, 0)
	
	if Input.is_action_pressed('Remove'):
		var is_bridge = rail_layer.is_a_bridge(cells[0])
		
		if is_bridge == null:
			return
		
		if !is_bridge:
			rail_layer.set_cells_terrain_connect(cells, 0, -1)

func placing_station():
	var map_pos = get_mouse_map_pos()
	
	var rail_type = rail_layer.get_rail_type(map_pos)
	if rail_type != "Straight" && rail_type != "Station":
		station_vert_sprite.modulate = Color(Color.WHITE, 0.0)
		station_hori_sprite.modulate = Color(Color.WHITE, 0.0)
		return
	
	var is_horizontal = true
	var directions = rail_layer.get_directions(map_pos)
	
	if Vector2i(directions[0]) == Vector2i.LEFT:
		is_horizontal = true
		station_hori_sprite.modulate = Color(Color.WHITE, 1.0)
		station_vert_sprite.modulate = Color(Color.WHITE, 0.0)
	else:
		is_horizontal = false
		station_hori_sprite.modulate = Color(Color.WHITE, 0.0)
		station_vert_sprite.modulate = Color(Color.WHITE, 1.0)
	
	var tile_pos = rail_layer.map_to_local(map_pos)
	station_hori_sprite.global_position = tile_pos
	station_vert_sprite.global_position = tile_pos
	
	var has_building = building_layer.has_building_neighbors(map_pos)
	
	if Input.is_action_pressed('Place') && has_building:
		if is_horizontal:
			rail_layer.set_cell(map_pos, 0, Vector2i(0, 2))
		else:
			rail_layer.set_cell(map_pos, 0, Vector2i(1, 2))
	
	if Input.is_action_pressed('Remove'):
		if is_horizontal:
			rail_layer.set_cell(map_pos, 0, Vector2i(0, 0))
		else:
			rail_layer.set_cell(map_pos, 0, Vector2i(0, 1))

func get_mouse_map_pos():
	var mouse_pos = get_global_mouse_position()
	return rail_layer.get_map_pos(mouse_pos)

func _on_buy_bridge_button(button : Control):
	var enough_money = money_manager.has_enough_money(button.cost_amount)
	
	if enough_money:
		money_manager.pay_money(button.cost_amount)
		var map_pos = button.map_pos
		rail_layer.build_bridge(map_pos)
		button.queue_free()
