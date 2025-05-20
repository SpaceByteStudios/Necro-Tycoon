extends Control

@onready var price_label = $Label

@export var map_pos : Vector2i
@export var cost_amount : int

signal buy_pressed(button)

func _ready() -> void:
	price_label.text = str(cost_amount)

func _on_button_pressed() -> void:
	buy_pressed.emit(self)
