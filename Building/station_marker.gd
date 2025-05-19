extends Node2D
class_name StationMarker

@onready var marker = $MarkerSprite

var amplitude = 2
var time = 0.0

var production : ProductType
var accepts : ProductType

func _process(delta: float) -> void:
	time += delta
	marker.position.y = amplitude * sin(time)
