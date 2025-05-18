extends Control

@onready var train_button = $VBox/HBox/Container/Margin/Buttons/TrainButton
@onready var rail_button = $VBox/HBox/Container/Margin/Buttons/RailButton
@onready var station_button = $VBox/HBox/Container/Margin/Buttons/StationButton


signal train_button_pressed
signal rail_button_pressed
signal station_button_pressed
signal button_toggled_off


func _on_train_button_toggled(toggle : bool) -> void:
	if toggle:
		rail_button.button_pressed = false
		station_button.button_pressed = false
		train_button_pressed.emit()

func _on_rail_button_toggled(toggle : bool) -> void:
	if toggle:
		train_button.button_pressed = false
		station_button.button_pressed = false
		rail_button_pressed.emit()

func _on_station_button_toggled(toggle : bool) -> void:
	if toggle:
		train_button.button_pressed = false
		rail_button.button_pressed = false
		station_button_pressed.emit()

func _on_button_toggled(toggle : bool) -> void:
	if toggle == false:
		button_toggled_off.emit()

func deselected_button():
	train_button.button_pressed = false
	rail_button.button_pressed = false
	station_button.button_pressed = false
