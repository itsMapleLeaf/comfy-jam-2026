extends Node

var inventory := InventoryState.new()
@onready var inventory_label: Label = %Inventory

var coffee_maker := CoffeeMachineState.new(inventory)
@onready var coffee_maker_label: Label = %CoffeeMachineState
@onready var add_grounds_button: Button = %AddGroundsButton
@onready var add_water_button: Button = %AddWaterButton
@onready var place_mug_button: Button = %PlaceMugButton
@onready var make_coffee_button: Button = %MakeCoffeeButton


class InventoryState:
	var grounds := 10
	var mugs := 10
	var coffee := 0


class CoffeeMachineState:
	var has_grounds := false
	var has_water := false
	var has_mug := false
	var inventory: InventoryState


	func _init(inventory_init: InventoryState) -> void:
		inventory = inventory_init


	func can_make_coffee() -> bool:
		return has_grounds and has_water and has_mug


	func make_coffee() -> void:
		if not can_make_coffee():
			return

		has_grounds = false
		has_water = false
		has_mug = false
		inventory.coffee += 1


func _ready() -> void:
	_render()


func _render() -> void:
	inventory_label.text = "\n".join(
		[
			"Grounds: %d" % inventory.grounds,
			"Clean Mugs: %d" % inventory.mugs,
			"Coffee: %d" % inventory.coffee,
		]
	)

	coffee_maker_label.text = "\n".join(
		[
			"Grounds: " + yes_no(coffee_maker.has_grounds),
			"Water: " + yes_no(coffee_maker.has_water),
			"Mug: " + yes_no(coffee_maker.has_mug),
		]
	)

	if inventory.grounds == 0:
		add_grounds_button.text = "Out of Grounds"
		add_grounds_button.disabled = true
	elif coffee_maker.has_grounds:
		add_grounds_button.text = "Added Grounds"
		add_grounds_button.disabled = true
	else:
		add_grounds_button.text = "Add Grounds"
		add_grounds_button.disabled = false

	add_water_button.disabled = coffee_maker.has_water

	if inventory.mugs == 0:
		place_mug_button.text = "Out of Mugs"
		place_mug_button.disabled = true
	elif coffee_maker.has_mug:
		place_mug_button.text = "Placed Mug"
		place_mug_button.disabled = true
	else:
		place_mug_button.text = "Place Mug"
		place_mug_button.disabled = false

	make_coffee_button.disabled = not coffee_maker.can_make_coffee()


func yes_no(yes: bool) -> String:
	return "Yes" if yes else "No"


func _on_add_grounds_button_pressed() -> void:
	coffee_maker.has_grounds = true
	inventory.grounds -= 1
	_render()


func _on_add_water_button_pressed() -> void:
	coffee_maker.has_water = true
	_render()


func _on_place_mug_button_pressed() -> void:
	coffee_maker.has_mug = true
	inventory.mugs -= 1
	_render()


func _on_make_coffee_button_pressed() -> void:
	coffee_maker.make_coffee()
	_render()
