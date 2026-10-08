class_name BrewingArea
extends Control

signal request_show_visitor_area

const ITEM_SLOT = preload("uid://c4todsa5032e2")

@onready var inventory_item_container: Control = %InventoryItems
@onready var brewing_slots: Control = %BrewingSlots
@onready var item_slot_context: ItemSlotContext = %ItemSlotContext


func _ready() -> void:
	_add_to_inventory(load("res://src/items/grounds_medium_roast.tres") as ItemSpec, 5)
	_add_to_inventory(load("res://src/items/mug_white.tres") as ItemSpec)
	_add_to_inventory(load("res://src/items/drink_coffee_light_roast.tres") as ItemSpec)

	for brewing_slot: BrewingSlot in brewing_slots.get_children():
		brewing_slot.register_item_slots(item_slot_context)

	item_slot_context.slot_changed.connect(_on_item_slot_context_slot_changed)

	_update()


func _on_item_slot_context_slot_changed() -> void:
	_update()


func _add_to_inventory(item_spec: ItemSpec, count := 1) -> void:
	var item := ItemState.new()
	item.spec = item_spec
	item.count = count

	var slot: ItemSlot = ITEM_SLOT.instantiate()
	inventory_item_container.add_child(slot)
	item_slot_context.register(slot)
	slot.sprite.item = item

	_update()


func _update() -> void:
	for slot: BrewingSlot in brewing_slots.get_children():
		slot.refresh()


func _on_front_counter_button_pressed() -> void:
	request_show_visitor_area.emit()
