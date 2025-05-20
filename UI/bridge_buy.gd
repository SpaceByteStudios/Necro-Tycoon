extends Control

@export var map_pos : Vector2i
@export var cost_amount : int

signal buy_pressed(button)

func _on_button_pressed() -> void:
	buy_pressed.emit(self)
