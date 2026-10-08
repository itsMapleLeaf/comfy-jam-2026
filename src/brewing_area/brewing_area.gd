class_name BrewingArea
extends Control

signal request_show_visitor_area

const ITEM_SLOT = preload("uid://c4todsa5032e2")

@onready var inventory_item_container: Control = %InventoryItems
@onready var brewing_slots: Control = %BrewingSlots
@onready var item_slot_context: ItemSlotContext = %ItemSlotContext


func _ready() -> void:
	_create_inventory_slots()

	_add_to_inventory_from_spec(load("res://src/items/grounds_medium_roast.tres") as ItemSpec, 3)
	_add_to_inventory_from_spec(load("res://src/items/mug_white.tres") as ItemSpec)
	_add_to_inventory_from_spec(load("res://src/items/mug_white.tres") as ItemSpec)
	_add_to_inventory_from_spec(load("res://src/items/mug_white.tres") as ItemSpec)
	_add_to_inventory_from_spec(load("res://src/items/drink_coffee_light_roast.tres") as ItemSpec)

	for brewing_slot: BrewingSlot in brewing_slots.get_children():
		brewing_slot.register_item_slots(item_slot_context)
		brewing_slot.brewed.connect(_on_brew)

	item_slot_context.slot_changed.connect(_on_item_slot_context_slot_changed)

	_update()


func _create_inventory_slots() -> void:
	for i in 20:
		var slot: ItemSlot = ITEM_SLOT.instantiate()
		inventory_item_container.add_child(slot)
		item_slot_context.register(slot)


func _on_brew(drink: ItemState) -> void:
	_add_to_inventory(drink)


func _on_item_slot_context_slot_changed() -> void:
	_update()


func _add_to_inventory(item: ItemState) -> void:
	var slot := _get_first_open_slot()
	if slot:
		slot.try_place(item)

	_update()


func _get_first_open_slot() -> ItemSlot:
	for slot: ItemSlot in inventory_item_container.get_children():
		if not slot.has_item():
			return slot

	return null


func _add_to_inventory_from_spec(item_spec: ItemSpec, count := 1) -> void:
	var item := ItemState.new()
	item.spec = item_spec
	item.count = count
	_add_to_inventory(item)


func _update() -> void:
	for slot: BrewingSlot in brewing_slots.get_children():
		slot.refresh()


func _on_front_counter_button_pressed() -> void:
	request_show_visitor_area.emit()
