extends Node2D
class_name StationMarker

@onready var marker = $MarkerSprite
@onready var production_icon = $MarkerSprite/ProductionIcon
@onready var product_label = $MarkerSprite/Label

var amplitude = 2
var time = 0.0

var production : Product
var accepts : Product

var products_amount : int = 0
var accept_amount : int = 0

var progress = 0.0

func _ready() -> void:
	production_icon.texture = production.product_icon
	show_products_amount()

func _process(delta: float) -> void:
	time += delta
	marker.position.y = amplitude * sin(time)
	
	marker.material.set_shader_parameter("progress", progress)
	
	var accept = accept_amount > 0 || production.always_produce
	if accept && products_amount < production.max_amount:
		progress += production.production_speed * delta
	
	if progress >= 1.0:
		progress = 0.0
		produce_product()

func get_accept(product : Product):
	if product.name != accepts.name:
		return false
	
	if accept_amount < accepts.max_amount:
		accept_amount += 1
		return true
	
	return false

func give_product() -> Product:
	if products_amount > 0:
		products_amount -= 1
		show_products_amount()
		return production.duplicate()
	
	return null

func produce_product():
	accept_amount -= 1
	products_amount += 1
	show_products_amount()

func show_products_amount():
	if production.name != "Nothing" && production.name != "Money":
		product_label.text = str(products_amount)
	else:
		product_label.visible = false
