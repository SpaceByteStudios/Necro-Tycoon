extends Resource
class_name Product

@export var name : String
@export var product_icon : Texture2D
@export var always_produce : bool
@export var production_speed : float
@export var product_color : Color = Color.WHITE


var amount = 0
@export var max_amount = 16
