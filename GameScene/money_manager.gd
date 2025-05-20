extends Node2D
class_name MoneyManager

@export var start_money = 50

var money_amount = 0

signal update_ui(money)

func _ready() -> void:
	money_amount = start_money
	call_deferred('update_money_ui')

func pay_money(money_cost):
	money_amount -= money_cost
	update_money_ui()

func get_money(money_pay):
	money_amount += money_pay
	update_money_ui()

func has_enough_money(money_cost):
	return money_amount >= money_cost

func update_money_ui():
	update_ui.emit(money_amount)
