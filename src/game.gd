class_name Game
extends Node

static var item_coffee_grounds := InventoryItem.new("Coffee Grounds", "Add to coffee maker")
static var item_coffee_mug := InventoryItem.new("Coffee Mug", "Place in coffee maker")
static var item_coffee_mug_used := InventoryItem.new("Coffee Mug (Used)", "Wash")
static var item_cup_of_coffee := InventoryItem.new("Cup of Coffee", "Drincc")

var inventory := Inventory.new()
@onready var inventory_item_list_container: Control = %InventoryItemListContainer

var coffee_maker := CoffeeMaker.new()
@onready var coffee_maker_label: Label = %CoffeeMachineState
@onready var add_water_button: Button = %AddWaterButton
@onready var make_coffee_button: Button = %MakeCoffeeButton


func _ready() -> void:
	_add_starting_inventory()
	_render()


func _add_starting_inventory() -> void:
	inventory.add_item(item_coffee_grounds, 10)
	inventory.add_item(item_coffee_mug, 10)


func _render() -> void:
	for child in inventory_item_list_container.get_children():
		child.queue_free()

	var counts := inventory.get_item_counts()
	for item in counts:
		var count := counts[item]

		var button := Button.new()
		button.text = "%s (x%d)" % [item.name, count]
		button.tooltip_text = item.tooltip

		button.pressed.connect(
			func():
				match item:
					item_coffee_grounds:
						if not coffee_maker.grounds:
							inventory.remove_item(item)
							coffee_maker.grounds = item
							_render()

					item_coffee_mug:
						if not coffee_maker.mug:
							inventory.remove_item(item)
							coffee_maker.mug = item
							_render()

					item_coffee_mug_used:
						inventory.remove_item(item)
						inventory.add_item(item_coffee_mug)
						_render()

					item_cup_of_coffee:
						inventory.remove_item(item)
						_render()
		)

		inventory_item_list_container.add_child(button)

	coffee_maker_label.text = "\n".join(
		[
			"Grounds: " + Helpers.yes_no(coffee_maker.grounds != null),
			"Water: " + Helpers.yes_no(coffee_maker.has_water),
			"Mug: " + Helpers.yes_no(coffee_maker.mug != null),
		]
	)

	add_water_button.disabled = coffee_maker.has_water
	make_coffee_button.disabled = not coffee_maker.can_make_coffee()


func _on_add_water_button_pressed() -> void:
	coffee_maker.has_water = true
	_render()


func _on_make_coffee_button_pressed() -> void:
	if coffee_maker.make_coffee():
		inventory.add_item(item_cup_of_coffee)
		inventory.add_item(item_coffee_mug_used)
		_render()


class InventoryItem:
	var name: String
	var tooltip: String


	func _init(name_init: String, tooltip_init: String) -> void:
		name = name_init
		tooltip = tooltip_init


class Inventory:
	var items: Array[InventoryItem] = []


	func add_item(item: InventoryItem, count := 1) -> void:
		for _i in count:
			items.append(item)


	func remove_item(item: InventoryItem) -> void:
		items.erase(item)


	func get_item_counts() -> Dictionary[InventoryItem, int]:
		var counts: Dictionary[InventoryItem, int] = { }
		for item in items:
			counts[item] = (counts[item] if item in counts else 0) + 1
		return counts


class CoffeeMaker:
	var grounds: InventoryItem = null
	var mug: InventoryItem = null
	var has_water := false


	func can_make_coffee() -> bool:
		return grounds and has_water and mug


	func make_coffee() -> InventoryItem:
		if not can_make_coffee():
			return null

		grounds = null
		mug = null
		has_water = false

		return Game.item_cup_of_coffee
