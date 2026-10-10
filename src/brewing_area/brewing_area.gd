class_name BrewingArea
extends Control

signal request_show_visitor_area

const ITEM_SLOT = preload("uid://c4todsa5032e2")

@onready var inventory_item_container: Control = %InventoryItems
@onready var brewing_slots: Control = %BrewingSlots
@onready var item_slot_context: ItemSlotContext = %ItemSlotContext


func _ready() -> void:
	_register_inventory_slots()

	for i in 5:
		var mug: MugInstance = _add_to_inventory(MugInstance.new())
		mug.spec = ItemLibrary.MUG_WHITE
		mug.effect = MugInstance.Effect.DarkenRoast.new()

	_add_to_inventory_from_spec(ItemLibrary.GROUNDS_LIGHT_ROAST, 3)
	_add_to_inventory_from_spec(ItemLibrary.GROUNDS_MEDIUM_ROAST, 3)
	_add_to_inventory_from_spec(ItemLibrary.GROUNDS_DARK_ROAST, 3)

	for brewing_slot: BrewingSlot in brewing_slots.get_children():
		brewing_slot.register_item_slots(item_slot_context)
		#brewing_slot.brewed.connect(_on_brew)

	item_slot_context.slot_changed.connect(_on_item_slot_context_slot_changed)

	_update()


func _register_inventory_slots() -> void:
	for slot: ItemSlot in inventory_item_container.get_children():
		item_slot_context.register(slot)


func _on_brew(drink: ItemInstance) -> void:
	_add_to_inventory(drink)


func _on_item_slot_context_slot_changed() -> void:
	_update()


func _add_to_inventory(item: ItemInstance) -> ItemInstance:
	var slot := _get_first_open_slot()
	if slot:
		slot.set_item_if_empty_and_accepted(item)

	_update()
	return item


func _get_first_open_slot() -> ItemSlot:
	for slot: ItemSlot in inventory_item_container.get_children():
		if not slot.has_item():
			return slot

	return null


func _add_to_inventory_from_spec(item_spec: ItemSpec, count := 1) -> ItemInstance:
	var item := ItemInstance.new()
	item.spec = item_spec
	item.count = count
	_add_to_inventory(item)
	return item


func _update() -> void:
	for slot: BrewingSlot in brewing_slots.get_children():
		slot.refresh()


func _on_front_counter_button_pressed() -> void:
	request_show_visitor_area.emit()

	for slot: BrewingSlot in brewing_slots.get_children():
		slot.apply_mug_effects()
