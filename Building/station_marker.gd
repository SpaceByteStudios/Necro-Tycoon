extends Node2D

@onready var marker = $MarkerSprite

var amplitude = 2
var time = 0.0

func _process(delta: float) -> void:
	time += delta
	marker.position.y = amplitude * sin(time)
