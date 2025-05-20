extends TrainWagon
class_name CarrierWagon

@onready var wagon_sprite = $WagonSprite

var station_manager : StationManager

@export var start_cargo : Product
@export var empty_cargo : Product
var cargo : Product

func _ready() -> void:
	cargo = start_cargo
	display_cargo()

func _on_station_area_body_entered(_body: Node2D) -> void:
	var map_pos = station_manager.get_cell_pos(global_position)
	var marker : StationMarker = station_manager.get_station_marker(map_pos)
	
	if cargo.name == "Nothing":
		var product = marker.give_product()
		
		if product != null:
			cargo = product
			display_cargo()
	else:
		var success = marker.get_accept(cargo)
		
		if success:
			cargo = empty_cargo
			display_cargo()


func display_cargo():
	var color = cargo.product_color
	wagon_sprite.material.set_shader_parameter("cargo_color", color)
