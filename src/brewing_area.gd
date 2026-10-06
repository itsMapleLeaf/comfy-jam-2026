class_name BrewingArea
extends Control

signal request_show_visitor_area

static var item_coffee_mug := Inventory.Item.new("Coffee Mug", "Place in coffee maker")
static var item_coffee_mug_used := Inventory.Item.new("Coffee Mug (Used)", "Wash")

var inventory := Inventory.new()
@onready var inventory_item_list_container: Control = %InventoryItemListContainer

var coffee_maker := CoffeeMaker.new()
@onready var coffee_maker_label: Label = %CoffeeMachineState
@onready var add_water_button: Button = %AddWaterButton
@onready var make_coffee_button: Button = %MakeCoffeeButton

enum CoffeeRoast {
	LIGHT,
	MEDIUM,
	DARK,
}


static func get_random_roast() -> CoffeeRoast:
	return (randi() % CoffeeRoast.size()) as CoffeeRoast


static func get_coffee_roast_name(roast: CoffeeRoast) -> String:
	return str(CoffeeRoast.find_key(roast)).capitalize()


class CoffeeGrounds extends Inventory.Item:
	var roast: CoffeeRoast
	var brewing_area: BrewingArea


	func _init(roast_init: CoffeeRoast, brewing_area_init: BrewingArea) -> void:
		roast = roast_init
		brewing_area = brewing_area_init
		super(
			"%s Roast Coffee Grounds" % BrewingArea.get_coffee_roast_name(roast),
			"Add to Coffee Maker",
		)


	func use() -> void:
		brewing_area.add_grounds_to_coffee_maker(self)


class CupOfCoffee extends Inventory.Item:
	var roast: CoffeeRoast
	var brewing_area: BrewingArea


	func _init(roast_init: CoffeeRoast, brewing_area_init: BrewingArea) -> void:
		roast = roast_init
		brewing_area = brewing_area_init
		super("Cup of %s Roast Coffee" % BrewingArea.get_coffee_roast_name(roast), "Drincc")


	func use() -> void:
		brewing_area.drink_coffee(self)


class CoffeeMaker:
	var grounds: CoffeeGrounds = null
	var mug: Inventory.Item = null
	var has_water := false


	func has_grounds() -> bool:
		return grounds != null


	func add_grounds_from_inventory(added_grounds: CoffeeGrounds, inventory: Inventory) -> void:
		grounds = added_grounds
		inventory.remove_item(added_grounds)


	func get_grounds_name() -> String:
		return grounds.name if grounds else "None"


	func can_make_coffee() -> bool:
		return grounds and has_water and mug


	func make_coffee(brewing_area: BrewingArea) -> CupOfCoffee:
		if not can_make_coffee():
			return null

		var coffee := CupOfCoffee.new(grounds.roast, brewing_area)

		grounds = null
		mug = null
		has_water = false

		return coffee


func _ready() -> void:
	_add_starting_inventory()
	_render()


func _add_starting_inventory() -> void:
	inventory.add_item(_create_coffee_grounds(CoffeeRoast.LIGHT), 5)
	inventory.add_item(_create_coffee_grounds(CoffeeRoast.MEDIUM), 5)
	inventory.add_item(_create_coffee_grounds(CoffeeRoast.DARK), 5)
	inventory.add_item(item_coffee_mug, 10)


func _create_coffee_grounds(roast: CoffeeRoast) -> Inventory.Item:
	return CoffeeGrounds.new(roast, self)


func add_grounds_to_coffee_maker(grounds: CoffeeGrounds) -> void:
	if not coffee_maker.has_grounds():
		coffee_maker.add_grounds_from_inventory(grounds, inventory)
		_render()


func drink_coffee(coffee: CupOfCoffee) -> void:
	inventory.remove_item(coffee)
	inventory.add_item(item_coffee_mug_used)
	_render()


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
					item_coffee_mug:
						if not coffee_maker.mug:
							inventory.remove_item(item)
							coffee_maker.mug = item
							_render()

					item_coffee_mug_used:
						inventory.remove_item(item)
						inventory.add_item(item_coffee_mug)
						_render()

					_:
						item.use()
		)

		inventory_item_list_container.add_child(button)

	coffee_maker_label.text = "\n".join(
		[
			"Grounds: " + coffee_maker.get_grounds_name(),
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
	var coffee := coffee_maker.make_coffee(self)
	if coffee:
		inventory.add_item(coffee)
		_render()


func _on_front_counter_button_pressed() -> void:
	request_show_visitor_area.emit()
